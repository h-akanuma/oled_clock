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
  DOT_FONT_PX  = 1
  DOT_STR      = '.'

  def initialize
    ENV['TZ'] = 'Asia/Tokyo'
    @display = Display.new
    @thermo_meter = ThermoMeter.new
    @time_str_buffer = ''
    @dots = 0
  end

  def redisplay_time(date_str, time_str)
    @display.clear
    @display.font_size(DATE_FONT_PX)
    @display.println(date_str)
    @display.font_size(TIME_FONT_PX)
    @display.println(time_str)
    @display.font_size(TEMP_FONT_PX)
    @display.println("#{@thermo_meter.read.round(1)} deg.C")
  end

  def display_dots(sec)
    @display.font_size(DOT_FONT_PX)
    (sec - @dots).times do
      @display.print(DOT_STR)
    end
    @dots = sec
  end

  def start
    begin
      loop do
        now = Time.now.localtime

        date_str = now.strftime(DATE_FORMAT)
        time_str = now.strftime(TIME_FORMAT)

        unless @time_str_buffer == time_str
          @time_str_buffer = time_str
          redisplay_time(date_str, time_str)
          @dots = 0
        end

        #display_dots(now.sec)

        @display.show
        sleep(1)
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
