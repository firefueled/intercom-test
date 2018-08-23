require 'json'

class DB
  attr_reader :ready

  def initialize(file_path)
    if file_path.nil? or file_path.empty?
      raise NoDataError.new("No data source provided")
    end

    unless File.readable?(file_path)
      raise FileInaccessibleError.new("File not found or unreadable")
    end

    begin
      parse_data(IO.readlines(file_path))
    rescue
      raise BadDataFormatError.new("Bad data format")
    end

    index_data
  end

  # gets the entire data set
  def get_all
    @data
  end

  # gets a fraction of it
  def get(qty = -1)
    @data[0..qty - 1]
  end

  # gets by a defined selector
  def get_by(selector)

  end

  def ready?
    @ready
  end

  private

  def parse_data(lines)
    @data = []
    lines.map { |line| @data.push(JSON.parse(line, symbolize_names: true)) }
  end

  def index_data
    # no need to index the data by a field right now
    @ready = true
  end

  class NoDataError < ArgumentError; end
  class FileInaccessibleError < ArgumentError; end
  class BadDataFormatError < ArgumentError; end
end
