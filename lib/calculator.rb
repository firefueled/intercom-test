class Calculator
  def initialize(db_instance)
    raise ArgumentError.new("No DB instance provided") if db_instance.nil?
    raise ArgumentError.new("DB instance is not ready") unless db_instance.ready?
    @office = { latitude: 53.339428, longitude: -6.257664 }
    @earth_radius = 6_371_008.8 # m
    @db = db_instance
    @data = @db.get_all
  end

  # distance in m
  def customers_within(max_distance = 100000)
    invited = @data.select { |x| great_circle_distance(x) <= max_distance }
    invited.sort { |a, b| a[:user_id] <=> b[:user_id] }
  end

  private

  def great_circle_distance(point, approach = :haversine)
    case approach
    when :haversine
      haversine(point)
    when :haversine2
      haversine2(point)
    when :law_of_cos
      law_of_cos(point)
    when :vincenty
      vincenty(point)
    end
  end

  def haversine(point)
    φ1 = @office[:latitude] * Math::PI / 180
    φ2 = point[:latitude].to_f * Math::PI / 180

    Δφ = (point[:latitude].to_f - @office[:latitude]).abs * Math::PI / 180
    Δλ = (point[:longitude].to_f - @office[:longitude]).abs * Math::PI / 180

    a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
        Math.cos(φ1) * Math.cos(φ2) *
        Math.sin(Δλ / 2) * Math.sin(Δλ / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    @earth_radius * c
  end

  def law_of_cos(point)
    φ1 = @office[:latitude] * Math::PI / 180
    φ2 = point[:latitude].to_f * Math::PI / 180

    Δλ = (point[:longitude].to_f - @office[:longitude]).abs * Math::PI / 180
    Δσ = Math.acos(
      Math.sin(φ1) * Math.sin(φ2) + Math.cos(φ1) * Math.cos(φ2) * Math.cos(Δλ)
    )

    @earth_radius * Δσ
  end

  def haversine2(point)
    φ1 = @office[:latitude] * Math::PI / 180
    φ2 = point[:latitude].to_f * Math::PI / 180

    Δφ = (point[:latitude].to_f - @office[:latitude]).abs * Math::PI / 180
    Δλ = (point[:longitude].to_f - @office[:longitude]).abs * Math::PI / 180

    cos_φ1 = Math.cos(φ1)
    cos_φ2 = Math.cos(φ2)

    sin_sq_φ = Math.sin(Δφ / 2) ** 2
    sin_sq_λ = Math.sin(Δλ / 2) ** 2
    rooted = sin_sq_φ + cos_φ1 * cos_φ2 * sin_sq_λ

    Δσ = 2 * Math.asin(Math.sqrt(rooted))
    @earth_radius * Δσ
  end

  def vincenty(point)
    throw NotImplementedError.new
  end
end