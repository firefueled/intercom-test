#!/usr/bin/env ruby
require 'optionparser'
require './lib/db'
require './lib/calculator'

class SimpleCals
  def parse(options)
    options = %w[--help] if options.empty?

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: simple_calcs.rb [options] [-f FILE_PATH] data"

      opts.on("-f", "--file FILE_PATH", "Path to a file containing input data") do |f|
        read_and_calculate(f)
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
  end

  def read_and_calculate(file_path)
    db = DB.new(file_path)
    calculator = Calculator.new(db)
    res = calculator.customers_within

    puts "The customers around a 100Km radius are the following:"
    res.map { |x| puts "User ID: #{x[:user_id]} - Name: #{x[:name]}" }

    exit
  end
end

simple_calcs = SimpleCals.new
options = simple_calcs.parse ARGV