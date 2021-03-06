# define class Thermometer
require_relative 'functions'
require 'optparse'

class Thermometer

  def initialize
  end

  def find_sensor()
    ## ::Initialize sensor location::
    ## On the Raspberry Pi, the device should connect in /sys/bus/w1/devices and
    ##   the sensor will attach to a directory that starts with 28-*****
    ##  - The sensor value will be in that directory, in a file called w1_slave
    ## Note: for testing, we can pass in a filename

    @slave_file = []      
    root_dir = '/sys/bus/w1/devices'
      
    if File.directory? File.expand_path(root_dir)
      if Dir[root_dir+"/28-*"].count == 1
        if Dir[root_dir+"/28-*/w1_slave"].count == 1
          @slave_file << Dir[root_dir+"/28-*/w1_slave"][0]
        else abort "ZOIKS: w1_slave file not found for device #{Dir[root_dir+"/28-*"]}"
        end
      else
        Dir[root_dir+"/28-*"].each do |s|
          @slave_file << s+"/w1_slave" 
          puts "Sensor: "+s+"/w1_slave"
        end
      end
    else abort "ZOIKS: devices directory not found"
    end
  end


  # reads the thermomter
    ## Reading the sensor has two lines:
    ##   Line 0:  tells you if the sensor is working (YES/NO)      - gauge_working_line
    ##   Line 1:  gives the temperature after "t=" in celcius*1000 - temperature_line
  def read
    temps = []
    @slave_file.each do |slave_file_location|
      puts "Reading from file: #{File.expand_path(slave_file_location)}"
      gauge_working_line = File.open(slave_file_location, &:readline)
      temperature_line = File.readlines(slave_file_location)[1]
      if gauge_working_line.split(' ').count >= 11
        position = gauge_working_line.split(' ').count - 1
        if gauge_working_line.split(' ')[position] == "YES"
          if temperature_line.split('=').count == 2
            temps << temperature_line.split('=')[1].gsub("\n","").to_f
          else abort "ZOIKS: not getting the right format for the temperature line: #{temperature_line.split(' ')}"
          end
        else abort "ZOIKS: looks like the thermometer isn't working right now"
        end
      else abort "ZOIKS: format wrong, found this on the first line: #{gauge_working_line.split(' ')}"
      end
    end
    return temps
  end

end

## add a couple classes to float to convert the readout to F and C, and chainable
class Float
  def to_fahrenheit
    ((self/1000)*9/5)+32
  end
  def to_celcius
    self/1000
  end
end
