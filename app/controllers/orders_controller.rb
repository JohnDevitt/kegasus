require 'open-uri'
require 'json'

#require 'tsp.rb'

require 'MultipleTravellingSalesman.rb'

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
      

    @depots = Depot.order(:address)
    @orders = Order.where("longitude IS NOT NULL AND fulfilled IS FALSE AND in_transit IS FALSE")

    puts "solving"

    mtsp = MultipleTravellilngSalesman.new @orders, @depots
    @tourList = mtsp.solve

    @hash = Array.new
    count = 0

    @tourList.each do |tour|

      @hash[count] = Gmaps4rails.build_markers(tour.getOrders) do |order, marker|
        marker.lat order.getLatitude
        marker.lng order.getLongitude
        marker.title order.getName
      end

        @hash[count].insert(0, lat: tour.getDepot.getLatitude, lng: tour.getDepot.getLongitude, title: tour.getDepot.getName)
        @hash[count].push(lat: tour.getDepot.getLatitude, lng: tour.getDepot.getLongitude, title: tour.getDepot.getName)
        count = count + 1
    end
  end

  # POST /orders
  # POST /orders.json
  def create

    @order = Order.new(order_params)
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
    @order.shopping_cart_id = @shopping_cart.id
    @order.fulfilled = false
    @order.in_transit = false

    if(user_signed_in?)
      @order.user_id = current_user.id
    else
      @order.user_id = -1
    end

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (@shopping_cart.total * 100).floor,
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