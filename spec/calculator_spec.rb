require 'calculator'

RSpec.describe Calculator do
  before(:example) do
    data = [
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
    @db = double("mock db instance", get_all: data, ready?: false)
  end

  context "#new" do
    it "checks for empty db instance" do
      expect { Calculator.new }.to raise_error(ArgumentError)
      expect { Calculator.new(nil) }.to raise_error(ArgumentError)
    end

    it "checks for db instance unreadyness" do
      expect { Calculator.new(@db) }.to raise_error(ArgumentError)
    end
  end
end
