require 'spec_helper'
require 'json'
require 'db'

RSpec.describe DB do
  before(:example) do
    @data = [
      {latitude: "52.986375", user_id: 12, name: "Christina McArdle", longitude: "-6.043701"},
      {latitude: "51.92893", user_id: 1, name: "Alice Cahill", longitude: "-10.27699"},
      {latitude: "51.8856167", user_id: 2, name: "Ian McArdle", longitude: "-10.4240951"}
    ]
    txt_data = @data.map { |x| JSON.dump(x) }
    IO.write('customers_test.txt', txt_data.join("\n"))
  end

  context "#new" do
    it "checks for blank file path" do
      expect { DB.new }.to raise_error(ArgumentError)
      expect { DB.new(nil) }.to raise_error(ArgumentError)
      expect { DB.new('') }.to raise_error(ArgumentError)
    end

    it "checks for inaccessible file" do
      expect { DB.new('9876trfvbnmk.87tfvb') }.to raise_error(DB::FileInaccessibleError)
    end

    it "checks for bad data format" do
      expect { DB.new('Gemfile') }.to raise_error(DB::BadDataFormatError)
    end

    it "becomes ready when valid data is loaded" do
      db = DB.new('customers_test.txt')
      expect(db.ready?).to be true
    end
  end

  context "#get" do
    it "can retrieve all data" do
      db = DB.new('customers_test.txt')
      res = db.get_all
      expect(res.length).to eq(@data.length)
      expect(res[0]).to eq(@data[0])
      expect(res[1]).to eq(@data[1])
      expect(res[2]).to eq(@data[2])
    end

    it "can retrieve part of the data" do
      db = DB.new('customers_test.txt')
      res = db.get(1)
      expect(res.length).to eq(1)
      expect(res[0]).to eq(@data[0])
    end
  end

  context "#handle problematic input" do
    it "ignores white spaces" do
      data = [
        {latitude: "52.986375", user_id: 12, name: "Christina McArdle", longitude: "-6.043701"},
        {latitude: "51.92893", user_id: 1, name: "Alice Cahill", longitude: "-10.27699"},
        {latitude: "51.8856167", user_id: 2, name: "Ian McArdle", longitude: "-10.4240951"}
      ]
      data.map! { |x| JSON.dump(x) }

      File.open('input_test.txt', 'w') do |file|
        file.write("\t      \n")

        file.write("#{data[0]}\n")
        file.write("#{data[1]}    \n")
        file.write("    #{data[2]}\n")

        file.write("   \t\n")
      end

      db = DB.new('input_test.txt')
      res = db.get_all

      expect(res.length).to be 3
      expect(res[0][:user_id]).to eq data[0][:user_id]
      expect(res[1][:user_id]).to eq data[1][:user_id]
      expect(res[2][:user_id]).to eq data[2][:user_id]

      File.delete('input_test.txt')
    end
  end

  after(:example) do
    File.delete('customers_test.txt')
  end
end
