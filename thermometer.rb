require 'bundler/setup'

SENSOR_FILE_PATH = '/sys/bus/w1/devices/28-*/w1_slave'.freeze

# For using thermo sensor DS18B20.
class ThermoMeter
  def initialize
    @device_file_name = Dir.glob(SENSOR_FILE_PATH).first
  end

  def read
    sensor_data = File.read(@device_file_name)
    sensor_data.match(/t=(.*$)/)[1].to_f / 1000
  end
end

if $PROGRAM_NAME == __FILE__
  thermo_meter = ThermoMeter.new
  loop do
    puts thermo_meter.read
    sleep(10)
  end
end
