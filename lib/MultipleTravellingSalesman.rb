
load 'TourManager.rb'
load 'DepotManager.rb'
load 'DepotCluster.rb'
load 'City.rb'


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

    tourList = Array.new

    depotClusterList.each do |cluster|
      tourList << cluster.solve
    end

    return tourList
  end

end

class Numeric
  def to_rad
    self * Math::PI / 180
  end
end

