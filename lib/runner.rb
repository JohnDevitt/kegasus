#!/usr/bin/env ruby

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
		return @name
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
	end
end



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

	def removeCity(city)
		@cities.delete(city)
	end

	def getSize()
		return @cities.size
	end

end

class GreedyAlgorithm

	def generateInitialTour (manager, depot)
		
		tour = Array.new
		current = findClosestTown(manager, depot)
		tour.push current
		manager.removeCity(current)


		for i in 0..manager.getSize - 1
			current = findClosestTown(manager, current)
			tour.push current
			manager.removeCity current
		end

		return tour
	end

	def findClosestTown(manager, city)
		
		closestYet = manager.getCity 0

		for i in 0..manager.getSize - 1

			if city.getDistance(manager.getCity(i)) < city.getDistance(closestYet)
				closestYet = manager.getCity(i)
			end
		end

		return closestYet
	end

end



class Runner

	def initialize(orders)
		@orders = orders
	end

	def slove()

		manager = TourManager.new

		@orders.each do |order|
			manager.addCity City.new order
		end

		depot = City.new 53.3880126, -6.3843862, "depot"

		algorithm = GreedyAlgorithm.new
		greedyTour = algorithm.generateInitialTour manager, depot

		result = Array.new
		greedyTour.each do |city|
			result.push city.getOrder
		end
	end

end
