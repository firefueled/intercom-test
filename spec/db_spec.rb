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

  context "#get" do
    before(:example) do
      @data = [
        {
          latitude: "52.986375",
          user_id: 12,
          name: "Christina McArdle",
          longitude: "-6.043701"
        },
        {
          latitude: "51.92893",
          user_id: 1,
          name: "Alice Cahill",
          longitude: "-10.27699"
        },
        {
          latitude: "51.8856167",
          user_id: 2,
          name: "Ian McArdle",
          longitude: "-10.4240951"
        }
      ]
      IO.write('customers.json', JSON.dump(@data))
    end

    it "can retrieve all data after loading it" do
      db = DB.new('customers.json')
      res = db.get_all
      expect(res.length).to be equal(@data.length)
      expect(res.first).to be equal(@data.first)
      expect(res.second).to be equal(@data.second)
      expect(res.third).to be equal(@data.third)
    end

    it "can retrieve part of the data after loading it" do
      db = DB.new('customers.json')
      res = db.get(1)
      expect(res.length).to be equal(1)
      expect(res.first).to be equal(@data.first)
    end

    after(:example) do
      File.delete('customers.json')
    end
  end
end
