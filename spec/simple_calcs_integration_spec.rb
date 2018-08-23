require 'json'

RSpec.describe "SimpleCals" do
  context "#command line" do
    it "doesn't crash and burn" do
      `ruby simple_calcs.rb`
      expect($?).to eq(0)
    end
    it "is bash-executable" do
      `./simple_calcs.rb`
      expect($?).to eq(0)
    end
    it "responds with a help message by default" do
      res = `./simple_calcs.rb`
      expect($?).to eq(0)
      expect(res.start_with?('Usage: simple_calcs.rb')).to be true
    end
  end

  context "#calculation" do
    before(:example) do
      @correct_results = JSON.parse(IO.read('./spec/customers_result.txt'), symbolize_keys: true)
      @correct_results.sort! { |a, b| a[:user_id] <=> b[:user_id] }
    end

    it "returns a result when given input as a file path" do
      res = `./simple_calcs.rb -f customers.txt`
      res_length = res.split("\n").length
      # the expected result is one line per customer plus one description line
      expect(res_length).to be >= @correct_results.length
      expect(res_length).to be < @correct_results.length + 1
    end
  end
end
