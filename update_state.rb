#!/usr/bin/env ruby
require_relative('thermometer')
require_relative('functions')
require('open-uri')

puts "\n*** Initializing Setup ***"
puts "Time: #{Time.now}"
t=Thermometer.new
#puts "Endpoint details:"
#puts "host: #{command_line_arguments[:endpoint].host}"
#puts "path: #{command_line_arguments[:endpoint].path}"
#puts "port: #{command_line_arguments[:endpoint].port}"
#puts "user: #{command_line_arguments[:endpoint].user}"
#puts "pswd: #{command_line_arguments[:endpoint].password}"

puts "\n*** Finding Sensor ***"
t.find_sensor()


puts "\n*** Checking Thermometer File ***"
readings = t.read

readings.each do |reading|
   puts "Reading in celcius: "+reading.to_celcius.to_s
   puts "Reading in fahrenheit: "+reading.to_fahrenheit.to_s
end

puts "\n*** Recording Temperature to Endpoint ***"
readings.each do |reading|
  puts "updating state of pool"
  fahrenheit = reading.to_fahrenheit
  puts "temperature recorded:  #{fahrenheit}"
  update_state(fahrenheit)
end
