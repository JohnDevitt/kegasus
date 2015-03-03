
load 'Manager.rb'
load 'Tour.rb'


class MultipleTravellilngSalesman

	def initialize(orders, depots)
    @orders = orders
    @depots = depots
  end

  def solve()

    # Create two manager objects, one to hold orders and one to hold depots
    orderManager = Manager.new
    orderManager.add_locations @orders

    depotManager = Manager.new
    depotManager.add_locations @depots

    # The list of the different routes
    tourList = Array.new

    #For each depot, create a tour, hold each Tour in a list
    depotManager.each do |depot|
      tourList << Tour.new(depot)
    end

    # Now we sort each order into the Tour with the closest depot
    orderManager.each do |order|
      currentTour = tourList[0]
      tourList.each do |tour|
        if(order.getDistance tour.getDepot) < (order.getDistance currentTour.getDepot)
          currentTour = tour
        end
      end

      currentTour.addOrder order
    end

    # And solve
    tourList.each do |tour|
        tour.solve
    end

    result = Array.new

    tourList.each do |tour|
      if (tour.size > 1)
        result << tour
      end
    end

    return result
  end

end

class Numeric
  def to_rad
    self * Math::PI / 180
  end
end

