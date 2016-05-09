require 'rubygems'
require 'mqtt'

client = MQTT::Client.new
client.host = ENV['aws-iot-endpoint']
client.port = 443
client.ssl = :TLSv1_2
client.cert_file = 'certs/pooltemp.cert'
client.key_file  = 'certs/pooltemp.key'
client.ca_file   = 'certs/rootca.pem'

client.connect()
client.publish('/things/pool/shadow', 'bar', retain=false)
client.disconnect()
