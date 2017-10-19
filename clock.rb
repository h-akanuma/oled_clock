require 'bundler/setup'
require './display.rb'
require './thermometer.rb'

class Clock
  TIMEZONE     = 'Asia/Tokyo'
  DATE_FORMAT  = '%Y/%m/%d'
  TIME_FORMAT  = '%H:%M'
  DATE_FONT_PX = 2
  TIME_FONT_PX = 4
  TEMP_FONT_PX = 2

  def initialize
    ENV['TZ'] = 'Asia/Tokyo'
    @display = Display.new
    @thermo_meter = ThermoMeter.new
    @time_str_buffer = ''
  end

  def redisplay_time(date_str, time_str)
    @display.clear
    @display.font_size(DATE_FONT_PX)
    @display.println(date_str)
    @display.font_size(TIME_FONT_PX)
    @display.println(time_str)
    @display.font_size(TEMP_FONT_PX)
    @display.println("#{@thermo_meter.read.round(1)} deg.C")
    @display.show
  end

  def start
    begin
      loop do
        sleep(1)

        now = Time.now.localtime

        date_str = now.strftime(DATE_FORMAT)
        time_str = now.strftime(TIME_FORMAT)

        next if @time_str_buffer == time_str

        @time_str_buffer = time_str
        redisplay_time(date_str, time_str)
      end
    rescue => e
      puts e.backtrace.join("\n")
    ensure
      @display.clear
    end
  end
end

if $PROGRAM_NAME == __FILE__
  clock = Clock.new
  clock.start
end
