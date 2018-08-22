class Calculator
  def initialize(db_instance)
    raise ArgumentError.new("No DB instance provided") if db_instance.nil?
    raise ArgumentError.new("DB instance is not ready") unless db_instance.ready?
  end

  # distance in km
  def customers_within(distance = 100)

  end
end