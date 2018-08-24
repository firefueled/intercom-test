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

    @ready = true
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
    @index = {}
    @data = []

    lines.map { |line|
      next if line.strip.length.zero?
      hash = JSON.parse(line, symbolize_names: true)

      next if any_empty_fields?(hash)
      next if @index.has_key?(hash[:user_id])

      hash[:latitude] = hash[:latitude].to_f
      hash[:longitude] = hash[:longitude].to_f

      next if out_of_range_coords?(hash)

      @data << hash
      @index[hash[:user_id]] = @data.length - 1
    }
  end

  def any_empty_fields?(hash)
    return true if
      hash[:user_id].nil? or
      hash[:latitude].nil? or
      hash[:longitude].nil? or
      hash[:name].nil?

    hash.any? { |k, v| String(v).empty? }
  end

  def out_of_range_coords?(hash)
    return true if hash[:latitude] > 90 or hash[:latitude] < -90
    return true if hash[:longitude] > 180 or hash[:longitude] < -180
    false
  end

  class NoDataError < ArgumentError; end
  class FileInaccessibleError < ArgumentError; end
  class BadDataFormatError < ArgumentError; end
end
