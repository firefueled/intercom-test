#!/usr/bin/env ruby
require 'optionparser'
require './db'
require './calculator'

options = {}
printers = Array.new

OptionParser.new do |opts|
  opts.banner = "Usage: simple_calcs [options] [[-f file_path] | [< piped_data]] file_path"
  opts.on("-f", "--file FILE_PATH", "Path to a file containing the data to be used") do |f|
    file_path = f
  end
end.parse!

