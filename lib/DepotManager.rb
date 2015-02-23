class DepotManager

  def initialize(depots)
    @depots = depots
  end

  def addDepot(depot)
    @depots.push depot
  end

  def getCity(index)
    return @depots.at index
  end

  def getSize()
    return @depots.size
  end

  def deepFreeze()
    @depots.freeze
    self.freeze
  end

  def each
    @depots.each do |depot|
      yield depot
    end
  end

end