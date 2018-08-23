#!/usr/bin/env ruby
require 'optionparser'
require './lib/db'
require './lib/calculator'

Options = Struct.new(:name)

class Parser
  def self.parse(options)
    options = %w[--help] if options.empty?

    args = Options.new("world")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: simple_calcs.rb [options] [-f FILE_PATH] data"

      opts.on("-f", "--file FILE_PATH", "Path to a file containing input data") do |f|
        options[:file_path] = f
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

options = Parser.parse ARGV