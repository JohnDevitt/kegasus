
load 'Tour.rb'
load 'Location.rb'


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

    tour = Tour.new Location.new route.depot
    route.orders.each do |order|
      tour.addOrder Location.new order
    end

    tour.solve


    unfulfilledOrders = 0

    tour.eachOrder do |order|
      if order.fulfilled == false
        unfulfilledOrders = unfulfilledOrders + 1
      end
    end

    if unfulfilledOrders == 0
      redirect_to :controller => "orders", :action => "delivery_locations"
    end

    depot = tour.getDepot
    depot_hash = Gmaps4rails.build_markers(depot) do |stop, marker|
      marker.lat stop.getLatitude
      marker.lng stop.getLongitude
      marker.title stop.getName
      
    end 

    @orders = tour.getOrders
  	@hash = Gmaps4rails.build_markers(@orders) do |stop, marker|
      if stop.fulfilled == false
    		marker.lat stop.getLatitude
    		marker.lng stop.getLongitude
    		marker.title stop.getName
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
