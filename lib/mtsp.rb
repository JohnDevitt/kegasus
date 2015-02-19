class MultipleTravellilngSalesman

	def initialize(orders, depots)
    @orders = orders
    @depots = depots
  end

  def solve()

    # Generate immutable city objects from our delivery addresses and depots, and store them in immutable managers

    tourManager = TourManager.new Array.new
    depotManager = DepotManager.new Array.new
    
    @orders.each do |order|
      tourManager.addCity (City.new order).freeze
    end
    tourManager.deepFreeze

    @depots.each do |depot|
      depotManager.addDepot (City.new depot).freeze
    end
    depotManager.deepFreeze

    # From out depotList, create depot clusters, which will hold the depot and the towns being serviced from that depot, our clusters can be
    # stored in an array

    depotClusterList = Array.new

    depotManager.each do |clusterCenter|
      depotClusterList << DepotCluster.new(clusterCenter, Array.new)
    end


    # We can now initially sort our towns into clusters with a basic algorithm, for each town, find the cluster with the closest center and
    # sort the town into that cluster

    tourManager.each do |city|
      nearestCluster = depotClusterList.at(0)
      depotClusterList.each do |cluster|
        if(cluster.getDistanceFromDepot city) < (nearestCluster.getDistanceFromDepot city)
          nearestCluster = cluster
        end
      end

      nearestCluster.addCity city
    end

    # for each cluster we slove the tsp and encode our routes in a Tour object

    #tourList = Array.new

    #depotClusterList.each do |cluster|
      #tourList << cluster.solve
    #end

    #return tourList
  end

end

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

###############################     Depot and Tour managers hold the initial list of depots and towns  #######################

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


class DepotCluster

	def initialize(depot, localCities)
		@depot = depot
		@localCities = localCities
	end

	def getDistanceFromDepot(town)
    return @depot.getDistance town
	end

	def addCity(town)
		@localCities << town
	end

  def solve
    array = Array.new

    array << @depot
    @localCities.each do |city|
      array << city
    end

    manager = TourManager.new array
    algorithm = GreedyAlgorithm.new

    greedyTour = algorithm.generateInitialTour manager
    optimizedTour = algorithm.optimize greedyTour

    result = Array.new
    for city in 0..optimizedTour.getSize - 1
      result.push optimizedTour.getCity(city).getOrder
    end

    return result
  end
end


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


class GreedyAlgorithm

  def generateInitialTour (manager)
    tour = Tour.new Array.new
    tour.addCity(manager.getCity(0))
    return populateTour(tour, manager)
  end

  def populateTour(tour, manager)
    if(tour.getSize == manager.getSize)
      return tour
    else
      tour.addCity(findNextCity(tour, manager))
      return populateTour(tour, manager)
    end
  end

  def findNextCity(tour, manager)
    shortestDistance = 1000000
    nearestNeighbour = tour.lastCity
    manager.each do |city|
      if( (tour.contains(city) == false) && (city.getDistance(tour.lastCity)) < shortestDistance )
        nearestNeighbour = city
      end
    end
    return nearestNeighbour
  end

  def optimize(tour)
    improved = true
    localTour = tour.clone
    bestDistance = localTour.getDistance

    while improved == true

      localTour = recursiveTwoOpt(0, 1, localTour)

      if localTour.getDistance < bestDistance
        bestDistance = localTour.getDistance
      else
        improved = false
      end
    end

    return localTour
  end

  def recursiveTwoOpt(outer, inner, tour)
      if(outer == tour.getSize - 1)
        return tour
      end

      if(inner == tour.getSize - 1)
        return recursiveTwoOpt((outer + 1), (outer + 2), tour)
      end

      reversedTour = reverseTour(outer, inner, tour)

      if(reversedTour.getDistance < tour.getDistance)
        return recursiveTwoOpt(outer, (inner + 1), reversedTour)
      end

      return recursiveTwoOpt(outer, (inner + 1), tour) 
  end

  def reverseTour(i, j, tour)
    localTour = Tour.new Array.new

    for a in 0..(i-1)
      localTour.addCity(tour.getCity(a))
    end

    count = 0
    for b in i..j
      localTour.addCity(tour.getCity(j - count))
      count = count + 1
    end

    for c in (j + 1)..(tour.getSize - 1)
      localTour.addCity(tour.getCity(c))
    end

    return localTour

  end

end