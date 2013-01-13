#!/usr/bin/env ruby
# generate-data.rb: Generate GTFS shapes.txt and stops.txt from current snapshot of data from shuttles.rpi.edu
# Author: Kenley Cheung <cheunk3 [at] rpi [dot] edu>
# Copyright (C) 2013 Rensselaer Polytechnic Institute
require 'json'
require 'net/http'

# Set data source here.
data_url = "http://shuttles.rpi.edu/displays/netlink.js"

# Magic happens here.
data_json = Net::HTTP.get(URI.parse('http://shuttles.rpi.edu/displays/netlink.js'))
netlink = JSON.parse(data_json)

# Open shapes.txt for writing
shapes = File.new("shapes.txt", "w+")
shapes.puts('shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence');
# Open stops.txt for writing
stops = File.new('stops.txt', "w+")
stops.puts('stop_id,stop_name,stop_lat,stop_lon')

puts "Writing out routes.txt"
for route in netlink["routes"]
  counter = 0
  print "Writing out route #{route["id"]} (#{route["name"]})"
  for coordinate in route["coords"]
    print "."
    shapes.puts("#{route["id"]},#{coordinate['latitude']},#{coordinate['longitude']},#{counter.to_s}")
    counter += 1
  end
  print "\n"
end

puts "Writing out stops.txt"
for stop in netlink["stops"]
  puts "#{stop["name"]}"
  stops.puts("#{stop["short_name"]},#{stop["name"]},#{stop["latitude"]},#{stop["longitude"]}")
end

# Close files
shapes.close
stops.close