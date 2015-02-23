class TourManager

  def initialize(cities)
    @cities = cities
  end

  def addCity(city)
    @cities.push city
  end

  def getCity(index)
    return @cities.at index
  end

  def getSize()
    return @cities.size
  end

  def deepFreeze()
    @cities.freeze
    self.freeze
  end

  def each
    @cities.each do |city|
      yield city
    end
  end

end