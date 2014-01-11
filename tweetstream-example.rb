$:.unshift(File.expand_path('lib'))
require 'status_statter'

StatusStatter.new.run do |status|
  puts "#{status.text}"
end
