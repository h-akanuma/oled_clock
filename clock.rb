require 'bundler/setup'
require './display.rb'

class Clock
  TIMEZONE     = 'Asia/Tokyo'
  DATE_FORMAT  = '%Y/%m/%d'
  TIME_FORMAT  = '%H:%M'
  DATE_FONT_PX = 1
  TIME_FONT_PX = 4
  DOT_FONT_PX  = 1
  DOT_STR      = '.'

  def initialize
    ENV['TZ'] = 'Asia/Tokyo'
    @display = Display.new
    @time_str_buffer = ''
    @dots = 0
  end

  def redisplay_time(date_str, time_str)
    @display.clear
    @display.font_size(DATE_FONT_PX)
    @display.println(date_str)
    @display.font_size(TIME_FONT_PX)
    @display.println(time_str)
  end

  def display_dots(sec)
    @display.font_size(DOT_FONT_PX)
    (sec - @dots).times do
      @display.print(DOT_STR)
    end
    @dots = sec
  end

  def start
    loop do
      now = Time.now.localtime
      puts now

      date_str = now.strftime(DATE_FORMAT)
      time_str = now.strftime(TIME_FORMAT)

      unless @time_str_buffer == time_str
        @time_str_buffer = time_str
        redisplay_time(date_str, time_str)
        @dots = 0
      end

      display_dots(now.sec)

      @display.show
      sleep(0.9)
    end
  end
end

if $0 == __FILE__
  clock = Clock.new
  clock.start
end
