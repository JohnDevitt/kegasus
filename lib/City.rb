class Numeric
  def to_rad
    self * Math::PI / 180
  end
end

class City

  def initialize(order)
    @order = order
  end

  def getName()
    return @order.address
  end

  def getLatitude()
    return @order.latitude
  end

  def getLongitude()
    return @order.longitude
  end

  def getOrder
    return @order
  end

  def getDistance(city)

    latitudeDifference = (city.getLatitude - @order.latitude).to_rad;
    longitudeDifference = (city.getLongitude - @order.longitude).to_rad;
    a = Math.sin(latitudeDifference / 2) * Math.sin(latitudeDifference / 2) +
    Math.cos(@order.latitude.to_rad) * Math.cos(city.getLatitude.to_rad) *
    Math.sin(longitudeDifference/2) * Math.sin(longitudeDifference/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    d = 6371 * c; # Multiply by 6371 to get Kilometers
    return d

    #sleep(1)

    #json = open('https://maps.googleapis.com/maps/api/directions/json?origin=' + @order.latitude.to_s + ',' + @order.longitude.to_s + '&destination=' + city.getLatitude.to_s + ',' + city.getLongitude.to_s).read
    #hash = JSON.parse json

    #puts hash

    #return hash['routes'][0]['legs'][0]['distance']['value']

  end
end