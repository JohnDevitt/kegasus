class RoutesController < ApplicationController
  def build_route

  	route = Route.new
  	locations = params[:tour]

  	route.depot = Depot.find(locations[0])
    puts route.depot.inspect

    for i in 1..locations.length - 1
      current_location = Order.find(locations[i])
  		route.orders << current_location
      current_location.in_transit = true
      current_location.save
  	end

  	route.save

    redirect_to :action => "show", :route=> route.id
  end

  def fulfil_order

    order = Order.find(params[:id])
    order.fulfilled = true
    order.save

    orders = Route.find(order.route_id).orders
    unfulfilledOrders = 0

    orders.each do |order|
      if order.fulfilled == false
        unfulfilledOrders = unfulfilledOrders + 1
      end
    end

    puts "----------------------------------"
    puts unfulfilledOrders
    puts "----------------------------------"

    if unfulfilledOrders > 0
      redirect_to :action => "show", :route=> Route.find(order.route_id)
    else
      redirect_to :controller => "orders", :action => "delivery_locations"
    end
  end

  
  def show

    route = Route.find(params[:route])

    orders = route.orders
    unfulfilledOrders = 0

    orders.each do |order|
      if order.fulfilled == false
        unfulfilledOrders = unfulfilledOrders + 1
      end
    end

    puts "----------------------------------"
    puts unfulfilledOrders
    puts "----------------------------------"

    if unfulfilledOrders == 0
      redirect_to :controller => "orders", :action => "delivery_locations"
    end

    depot = route.depot
    depot_hash = Gmaps4rails.build_markers(depot) do |stop, marker|
      marker.lat stop.latitude
      marker.lng stop.longitude
      marker.title stop.address
      
    end 

    @orders = route.orders
  	@hash = Gmaps4rails.build_markers(@orders) do |stop, marker|
      if stop.fulfilled == false
    		marker.lat stop.latitude
    		marker.lng stop.longitude
    		marker.title stop.address
      end
  	end

    @hash.delete_if {|location| location == {} }

    puts @hash.inspect
    @hash = depot_hash + @hash
  end

  def gmaps4rails_marker_picture
 {
  "picture" => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=A|123123|000000",          # string,  mandatory
   "width" => 32 ,          # integer, mandatory
   "height" => 32,          # integer, mandatory
 }
end

end
