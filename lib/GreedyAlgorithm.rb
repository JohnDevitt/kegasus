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