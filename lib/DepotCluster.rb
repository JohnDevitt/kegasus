
load 'TourManager.rb'
load 'GreedyAlgorithm.rb'

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
    puts " CLEED"

    return return_depot_to_head_of_list result
  end

  def return_depot_to_head_of_list(solution)


    while solution[0].getName != @depot.getName
      solution.rotate
    end

    return solution
  end
end