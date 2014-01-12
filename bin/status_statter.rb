#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
require 'status_statter'
Dir['status_statter/trackers/total/*.rb'].each {|file| require file }
statter = StatusStatter.new
statter.register Total
statter.run
