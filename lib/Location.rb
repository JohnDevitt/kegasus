
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

  def getDistance location
    latitudeDifference = (location.getLatitude - @location.latitude).to_rad;
    longitudeDifference = (location.getLongitude - @location.longitude).to_rad;
    a = Math.sin(latitudeDifference / 2) * Math.sin(latitudeDifference / 2) +
    Math.cos(@location.latitude.to_rad) * Math.cos(location.getLatitude.to_rad) *
    Math.sin(longitudeDifference/2) * Math.sin(longitudeDifference/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    d = 6371 * c;
    return d

  end
end