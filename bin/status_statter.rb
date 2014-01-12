#!/usr/bin/env ruby
dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$:.unshift(File.join(dir, 'lib'))
require 'status_statter'
require 'awesome_print'
Dir[File.join(dir, 'lib/status_statter/trackers/*.rb')].each do |file|
  require file
end
statter = StatusStatter.new
statter.register Total.new, AverageOverTime.new
puts "Here we go, hit control-c to stop..."
trap("SIGINT") { statter.stop }
statter.run
puts "started: #{statter.start_time}"
puts "stopped: #{statter.stop_time}"
ap statter.results
