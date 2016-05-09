require 'net/http'
require 'open-uri'
require 'json'
require 'mqtt'


def record_temp(temp)
  @payload ={"reading"=>{"location"=>"pool", "temperature"=>temp, "recorded_at"=>Time.now}}.to_json
  #req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
  #req.body = @payload
  #response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
  #puts "Response #{response.code} #{response.message}:
  #{response.body}"

  client = MQTT::Client.new
  client.host = 'g.us-east-1.pb.iot.amazonaws.com'
  client.port = 443
  client.ssl = :TLSv1_2
  client.cert_file = 'certs/pooltemp.cert'
  client.key_file  = 'certs/pooltemp.key'
  client.ca_file   = 'certs/rootca.pem'

  client.connect()
  client.publish('pooltemp', @payload, retain=false)
  client.disconnect()
end

def update_state(temp)
  @payload ={"state"=>{"reported"=>{"temperature"=>temp}}}.to_json

  client = MQTT::Client.new
  client.host = ENV['AWSIOTENDPOINT']
  client.port = 443
  client.ssl = :TLSv1_2
  client.cert_file = 'certs/pooltemp.cert'
  client.key_file  = 'certs/pooltemp.key'
  client.ca_file   = 'certs/rootca.pem'

  client.connect()
  client.publish('/things/pool/shadow', @payload, retain=false)
  client.disconnect()
end
