#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
require 'status_statter'
require 'status_statter/trackers/total'

statter = StatusStatter.new
statter.register Total
statter.run
