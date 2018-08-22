require 'json'

class DB
  attr_reader :ready

  def initialize(file_path)
    if file_path.nil? or file_path.empty?
      raise ArgumentError.new("No data source provided")
    end

    unless File.readable?(file_path)
      raise ArgumentError.new("File not found or unreadable")
    end

    begin
      json_data = JSON.parse(IO.read(file_path))
    rescue
      raise ArgumentError.new("JSON data is malformed")
    end

    index_data(json_data)
  end

  # gets the entire data set
  def get_all

  end

  # gets a fraction of it
  def get(qty = -1)

  end

  # gets by a defined selector
  def get_by(selector)

  end

  def ready?
    @ready
  end

  private

  def index_data(data)

    @ready = true
  end
end
