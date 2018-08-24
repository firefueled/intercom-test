# Intercom Test
Command line app built with Ruby

## Requirements
Ruby 2.5

## Install
Install bundler

`gem install bundler`

and dependencies

`bundle install`

## Usage
Simply pass any data file using the -f option

A working example is available in `spec/customers.txt`

`ruby simple_calcs.rb -f spec/customers.txt`

Give it execution permissions to use it as bash script

`chmod +x simple_calcs.rb`

`./simple_calcs.rb -f spec/customers.txt`

`-h` flag prints out a help text

## Tests

Run tests with

`rspec`