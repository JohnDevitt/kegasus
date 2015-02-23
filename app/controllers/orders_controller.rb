require 'open-uri'
require 'json'

#require 'tsp.rb'

require 'mtsp.rb'

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
      
    @orders = Order.where(fulfilled: false)
    @depots = Depot.order(:address)

    salesmen = MultipleTravellilngSalesman.new @orders, @depots
    @clusterList = salesmen.solve

    @hash = Array.new
    count = 0

    @clusterList.each do |cluster|

      #puts "====================================================="
      #puts cluster.inspect
      #puts "====================================================="

      @hash[count] = Gmaps4rails.build_markers(cluster) do |order, marker|
        marker.lat order.latitude
        marker.lng order.longitude
        marker.title order.address
      end

        @hash[count].push(lat: cluster.at(0).latitude, lng: cluster.at(0).longitude, title: cluster.at(0).address)
        count = count + 1
    end





      #@orders = Order.where(fulfilled: false)

      #salesman = Salesman.new @orders
      #@orders = salesman.solve

      #@hash = Gmaps4rails.build_markers(@orders) do |order, marker|
       # marker.lat order.latitude
       # marker.lng order.longitude
       # marker.title order.address
      #end

      #@hash.push(lat: @orders.at(0).latitude, lng: @orders.at(0).longitude)
  end

  def fulfil_order
    @order = Order.find(params[:id])
    puts @order.inspect
    @order.fulfilled = true
    @order.save
    redirect_to action: :delivery_locations
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