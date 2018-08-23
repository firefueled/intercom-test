#!/usr/bin/env ruby
require 'optionparser'
require './lib/db'
require './lib/calculator'

ERR_MISSING_FILE_PATH = 1
ERR_FILE_INACCESSIBLE = 2
ERR_BAD_FILE_FORMAT = 3

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
    begin
      db = DB.new(file_path)

    rescue DB::FileInaccessibleError => e
      puts 'Input file inaccessible. Please provide one with the -f option and make sure it\'s readable.'
      exit ERR_FILE_INACCESSIBLE

    rescue DB::BadDataFormatError => e
      puts 'Input file has a broken format. The file should have a single JSON object per line.'
      exit ERR_BAD_FILE_FORMAT
    end

    calculator = Calculator.new(db)
    res = calculator.customers_within

    puts "The customers around a 100Km radius are the following:"
    res.map { |x| puts "User ID: #{x[:user_id]} - Name: #{x[:name]}" }

    exit
  end
end

simple_calcs = SimpleCals.new

begin
  options = simple_calcs.parse ARGV
rescue OptionParser::MissingArgument => e
  puts 'No input file path provided. Please provide one with the -f option.'
  exit ERR_MISSING_FILE_PATH
end