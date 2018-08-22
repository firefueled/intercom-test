require 'spec_helper'
require 'json'
require 'db'

RSpec.describe DB do
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
    txt_data = @data.map { |x| JSON.dump(x) }
    IO.write('customers.txt', txt_data.join("\n"))
  end

  context "#new" do
    it "checks for blank file path" do
      expect { DB.new }.to raise_error(ArgumentError)
      expect { DB.new(nil) }.to raise_error(ArgumentError)
      expect { DB.new('') }.to raise_error(ArgumentError)
    end

    it "checks for inaccessible file" do
      expect { DB.new('9876trfvbnmk.87tfvb') }.to raise_error(ArgumentError)
    end

    it "checks for bad data format" do
      expect { DB.new('Gemfile') }.to raise_error(ArgumentError)
    end

    it "becomes ready when valid data is loaded" do
      db = DB.new('customers.txt')
      expect(db.ready?).to be true
      File.delete('customers.txt')
    end
  end

  context "#get" do
    it "can retrieve all data after loading it" do
      db = DB.new('customers.txt')
      res = db.get_all
      expect(res.length).to be equal(@data.length)
      expect(res.first).to be equal(@data.first)
      expect(res.second).to be equal(@data.second)
      expect(res.third).to be equal(@data.third)
    end

    it "can retrieve part of the data after loading it" do
      db = DB.new('customers.txt')
      res = db.get(1)
      expect(res.length).to be equal(1)
      expect(res.first).to be equal(@data.first)
    end

    after(:example) do
      File.delete('customers.txt')
    end
  end
end
