
# A location object can be an order or a depot. it provides an interface to access the objects location data
# and name. It also holds a reference to the original object that was passed in.

class Location

  def initialize location
    @location = location
    self.freeze
  end

  def getName
    return @location.address
  end

  def getLatitude
    return @location.latitude
  end

  def getLongitude
    return @location.longitude
  end

  def getId
    return @location.id
  end

  def fulfilled
    return @location.fulfilled
  end

  def getDistance location
    latitudeDifference = to_rad (location.getLatitude - @location.latitude);
    longitudeDifference = to_rad (location.getLongitude - @location.longitude);
    a = Math.sin(latitudeDifference / 2) * Math.sin(latitudeDifference / 2) +
    Math.cos(to_rad @location.latitude) * Math.cos(to_rad location.getLatitude) *
    Math.sin(longitudeDifference/2) * Math.sin(longitudeDifference/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    d = 6371 * c;
    return d

  end

  def to_rad num
    num * Math::PI / 180
  end
end