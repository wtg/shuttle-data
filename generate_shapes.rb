#!/usr/bin/env ruby
# generate_shapes.rb: Generate GTFS shapes.txt from current snapshot of data from shuttles.rpi.edu
# Author: Kenley Cheung <cheunk3 [at] rpi [dot] edu>
# Copyright (C) 2013 Rensselaer Polytechnic Institute
require 'json'
require 'net/http'

# Set data source here.
data_url = "http://shuttles.rpi.edu/displays/netlink.js"

# Magic happens here.
data_json = Net::HTTP.get(URI.parse('http://shuttles.rpi.edu/displays/netlink.js'))
netlink = JSON.parse(data_json)

# Open file to write
shapes = File.new("shapes.txt", "w+")
shapes.puts('shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence');

for route in netlink["routes"]
  # Do stuff
  counter = 0
  print "Writing out route #{route["id"]} (#{route["name"]})"
  for coordinate in route["coords"]
    print "."
    shapes.puts("#{route["id"]},#{coordinate['latitude']},#{coordinate['longitude']},#{counter.to_s}")
    counter += 1
  end
  print "\n"
end

shapes.close