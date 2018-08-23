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
end
