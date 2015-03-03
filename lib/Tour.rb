
# A tour object is a depot and an array of of orders, it has a sort sort function so therefore it can have
# an ordering.



class Tour

  def initialize depot
    @depot = depot
    @orders = Array.new
  end

  def setOrders array
    @orders = array
  end

  def addOrder order
    @orders.push order
  end

  def getDepot
    return @depot
  end

  def getOrders
    return @orders
  end

  def getIdArray
    idArray = Array.new
    idArray.push @depot.getId

    @orders.each do |order|
      idArray.push order.getId
    end

    return idArray
  end

  def eachLocation
    yield @depot

    @orders.each do |order|
      yield order
    end
  end

  def eachOrder
    @orders.each do |order|
      yield order
    end
  end

  def size
    # The depot is part of the tour size, hence the + 1
    return @orders.size + 1
  end

  def getDistance()
  total = 0

    total = total + @depot.getDistance(@orders[0])

    for i in 1..@orders.size - 2
      total = total + @orders[i].getDistance(@orders[i + 1])
    end

    total = total + @depot.getDistance(@orders[@orders.size - 1])

    return total
  end

  def solve

    if @orders.size == 0
      return
    end

    new_orders = Array.new

    currentNearestNeighbour = @orders[0]
        @orders.each do |order|
          if (@depot.getDistance order) < (@depot.getDistance currentNearestNeighbour)
            currentNearestNeighbour = order
          end
        end

        @orders.delete_at (@orders.index currentNearestNeighbour)
        new_orders.push currentNearestNeighbour

    while @orders.size > 0

        currentNearestNeighbour = @orders[0]
        @orders.each do |order|
          if (new_orders.last.getDistance order) < (new_orders.last.getDistance currentNearestNeighbour)
            currentNearestNeighbour = order
          end
        end

        @orders.delete_at (@orders.index currentNearestNeighbour)
        new_orders.push currentNearestNeighbour
    end

    @orders = new_orders

    self.optimize

  end

  def getArrayDistance array
    total = 0

    for i in 0..array.size - 2
      total = total + array[i].getDistance(array[i + 1])
    end

    total = total + array[array.size - 1].getDistance(array[0])

    return total
  end

  def optimize
    improved = true
    localTour = Array.new
    eachLocation do |loc|
      localTour.push loc
    end
    shortestDistance = getArrayDistance localTour

    puts getDistance
    puts shortestDistance

    while improved == true

      localTour = recursiveTwoOpt(0, 1, localTour)

      # Repeat while we're improving
      if((getArrayDistance localTour) < shortestDistance)
        shortestDistance = getArrayDistance localTour
      else
        improved = false
      end
    end

    while localTour[0] != @depot
      localTour = localTour.rotate
    end

    @depot = localTour.delete_at 0
    @orders = localTour
  end

  def recursiveTwoOpt(outer, inner, tour)

    if(outer == tour.size - 1)
        return tour
      end

      if(inner == tour.size - 1)
        return recursiveTwoOpt((outer + 1), (outer + 2), tour)
      end

      reversedTour = reverseTour(outer, inner, tour)

      if((getArrayDistance reversedTour) < (getArrayDistance tour))
        return recursiveTwoOpt(outer, (inner + 1), reversedTour)
      end

      return recursiveTwoOpt(outer, (inner + 1), tour) 
  end

  def reverseTour(i, j, tour)
    localTour = Array.new

    for a in 0..(i-1)
      localTour.push(tour[a])
    end

    count = 0
    for b in i..j
      localTour.push(tour[j - count])
      count = count + 1
    end

    for c in (j + 1)..(tour.size - 1)
      localTour.push(tour[c])
    end

    return localTour

  end

end