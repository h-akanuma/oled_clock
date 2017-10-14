require 'bundler/setup'
require 'SSD1306'

include Magick

class Display
  def initialize
    @disp = SSD1306::Display.new
  end

  def font_size(size)
    @disp.font_size = size
  end

  def show
    @disp.display!
  end

  def clear
    @disp.clear!
  end

  def println(str)
    @disp.println(str)
  end

  def print(str)
    @disp.print(str)
  end
end

if $0 == __FILE__
  display = Display.new
  display.execute
end
