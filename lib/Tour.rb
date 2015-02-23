class Tour

  def initialize(cities)
    @cities = cities
  end

  def addCity(city)
    @cities.push city
  end

  def getCity(index)
    return @cities.at(index)
  end

  def setCity(index, city)
    @cities[index] = city
  end

  def lastCity()
    return @cities.last
  end

  def getSize()
    return @cities.size
  end

  def contains(test)
    if(@cities.include? test)
      return true
    end

    return false
  end

  def getDistance()
    total = 0

    for i in 0..@cities.size - 2
      total = total + @cities.at(i).getDistance(@cities.at(i + 1))
    end

    total = total + @cities.at(@cities.size - 1).getDistance(@cities.at(0))

    return total
  end

  def each
    @cities.each do |city|
      yield city
    end
  end
end