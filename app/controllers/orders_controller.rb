class OrdersController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  def delivery_locations
    puts "----------------------------------------------------------------------------------------"
      @orders = Order.where(fulfilled: false)

      salesman = Salesman.new @orders
      @orders = salesman.solve

      @hash = Gmaps4rails.build_markers(@orders) do |order, marker|
        marker.lat order.latitude
        marker.lng order.longitude
      end

      @hash.push(lat: @orders.at(0).latitude, lng: @orders.at(0).longitude)

    puts "----------------------------------------------------------------------------------------"
  end

  # POST /orders
  # POST /orders.json
  def create

    @order = Order.new(order_params)
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
    @order.shopping_cart_id = @shopping_cart.id
    @order.fulfilled = false

    if(user_signed_in?)
      @order.user_id = current_user.id
    else
      @order.user_id = -1
    end

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (1000).floor,
        :currency => "eur",
        :card => token
        )
      flash[:notice] = "We're on our way!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end

    session[:shopping_cart_id] = ShoppingCart.new.id

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_url}
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :town, :county, :phone)
    end
end




################################################# TSP CODE ################################################################




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


class Tour

  def initialize(cities)
    @cities = cities
  end

  def setCity(index, city)
    @cities[index] = city
  end

  def addCity(city)
    @cities.push city
  end

  def getCity(index)
    return @cities.at(index)
  end

  def removeCity(city)
    @cities.delete(city)
  end

  def getDistance()
    total = 0

    for i in 0...getSize - 2
      total += @cities.at(i).getDistance(@cities.at(i + 1))
    end

    return total
  end

  def getSize()
    return @cities.size
  end

end

class GreedyAlgorithm

  def generateInitialTour (manager)
    
    tour = Tour.new Array.new
    current = manager.getCity 0
    tour.addCity current
    manager.removeCity current

    for i in 0..manager.getSize - 1
      current = findClosestTown(manager, current)
      tour.addCity current
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

  def twoOptSwap(tour, i, j)
    newTour = Tour.new Array.new

    for x in 0..(i-1)
      newTour.addCity tour.getCity(x)
    end

    count = 0
    for y in i..j
      city = tour.getCity(j - count)
      newTour.addCity(city)
      count = count + 1
    end

    for z in (j + 1)..(tour.getSize - 1)
      newTour.addCity(tour.getCity(z))
    end

    return newTour
  end

  def twoOptSearch(tour, bestDistance)

    for i in 0..tour.getSize - 1
      for j in i..tour.getSize - 1
       testRoute = twoOptSwap tour, i, j
        if testRoute.getDistance < bestDistance
          puts testRoute.getDistance
          puts bestDistance
          puts "-------------------------------------------------------"
         tour = testRoute
         return tour
        end
      end
    end

    return tour

  end

  def twoOptAlgorithm(tour)
    
    improved = true
    while(improved == true)

      bestDistance = tour.getDistance
      tour = twoOptSearch tour, bestDistance
      if tour.getDistance == bestDistance
        puts bestDistance
        improved = false
      end
    end

    return tour
  end

end



class Salesman

  def initialize(orders)
    @orders = orders
  end

  def solve()

    manager = TourManager.new Array.new

    @orders.each do |order|
      manager.addCity City.new order
    end

    algorithm = GreedyAlgorithm.new
    greedyTour = algorithm.generateInitialTour manager
    optimizedTour = algorithm.twoOptAlgorithm greedyTour

    result = Array.new
    for city in 0..optimizedTour.getSize - 1
      result.push optimizedTour.getCity(city).getOrder
    end

    return result
  end

end