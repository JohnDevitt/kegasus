
# A Manager object hold an initial unsorted list of Location objects. The purpose of this structure is to provide an interface
# that objects lower level objects can use to search and sort through lists of location objects.

load 'Location.rb'

class Manager

  def initialize
    @locations = Array.new
  end

  def add_locations raw_locations
    raw_locations.each do |location|
      @locations.push (Location.new location)
    end
    self.deepFreeze
  end

  def getCity index
    return @locations.at index
  end

  def getSize
    return @locations.size
  end

  def deepFreeze
    @locations.freeze
    self.freeze
  end

  def each
    @locations.each do |location|
      yield location
    end
  end

end