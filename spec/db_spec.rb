require 'spec_helper'
require 'json'
require 'db'

RSpec.describe DB do
  context "#new" do
    it "checks for blank file path" do
      expect { DB.new }.to raise_error(ArgumentError)
      expect { DB.new(nil) }.to raise_error(ArgumentError)
      expect { DB.new('') }.to raise_error(ArgumentError)
    end

    it "checks for inaccessible file" do
      expect { DB.new('9876trfvbnmk.87tfvb') }.to raise_error(ArgumentError)
    end

    it "checks for bad JSON data" do
      expect { DB.new('Gemfile') }.to raise_error(ArgumentError)
    end

    it "becomes ready when valid data is loaded" do
      IO.write(
        'carlos.json',
        JSON.dump({ name: 'carlos', age: 3, aliases: [ 'hi', 'lo' ] })
      )

      db = DB.new('carlos.json')
      expect(db.ready?).to be true
      File.delete('carlos.json')
    end
  end
end
