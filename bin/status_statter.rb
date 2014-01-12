#!/usr/bin/env ruby
dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$:.unshift(File.join(dir, 'lib'))
require 'status_statter'
Dir[File.join(dir, 'lib/status_statter/trackers/*.rb')].each do |file|
  require file
end
statter = StatusStatter.new
statter.register Total
trap("SIGINT") { statter.stop }
statter.run
puts "started: #{statter.start_time.inspect}"
puts "stopped: #{statter.stop_time.inspect}"
puts statter.results.inspect
