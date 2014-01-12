#!/usr/bin/env ruby
dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$:.unshift(File.join(dir, 'lib'))
require 'status_statter'
Dir[File.join(dir, 'lib/status_statter/trackers/*.rb')].each do |file|
  require file
end
statter = StatusStatter.new
statter.register Total
statter.run
