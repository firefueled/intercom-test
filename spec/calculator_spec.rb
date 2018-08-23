require 'calculator'

RSpec.describe Calculator do
  before(:example) do
    @data = [
      # 352 Kms out bearing 97deg
      {
        latitude: "52.84101684721",
        user_id: 12,
        name: "Christina McArdle",
        longitude: "-1.06811365826"
      },
      # 95 Kms out bearing 29deg
      {
        latitude: "54.08349035189",
        user_id: 2,
        name: "Ian McArdle",
        longitude: "-5.5526349267"
      },
      # 4.5 Kms out bearing 17deg
      {
        latitude: "53.37894446001",
        user_id: 1,
        name: "Alice Cahill",
        longitude: "-6.23740995419"
      }
    ]
    @db = double("mock db instance", get_all: @data, ready?: false)
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

  context "#customers_within" do
    before(:example) do
      allow(@db).to receive(:ready?) { true }
    end

    it "returns customers within 100Km" do
      calc = Calculator.new(@db)
      res = calc.customers_within
      expect(res.length).to eq(2)
      expect(@data[2]).to eq(res[0])
      expect(@data[1]).to eq(res[1])
    end
  end
end
