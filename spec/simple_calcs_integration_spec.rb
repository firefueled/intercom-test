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
      @correct_results = JSON.parse(IO.read('./spec/customers_result.txt'), symbolize_names: true)
      @correct_results.sort! { |a, b| a[:user_id] <=> b[:user_id] }
    end

    it "returns a correct result when given the example input file" do
      res = `./simple_calcs.rb -f spec/customers.txt`
      res_lines = res.split("\n")
      expect($?).to eq(0)

      # the expected result is one line per customer plus one description line
      expect(res_lines.length).to eq @correct_results.length + 1

      expect(res_lines[0].start_with?("The customers around")).to be true

      # check the text output lines for correctness
      @correct_results.map.with_index { |x, i|
        expect(res_lines[i + 1].start_with?("User ID: #{x[:user_id]}")).to be true
        expect(res_lines[i + 1].end_with?(x[:name])).to be true
      }
    end
  end
end
