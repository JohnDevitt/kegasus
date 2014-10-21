class ShoppingCartsController < ApplicationController
	before_filter :extract_shopping_cart
  before_action :set_shopping_cart, only: [:show, :edit, :update, :destroy]

  # GET /shopping_carts
  # GET /shopping_carts.json
  def index
    @shopping_carts = ShoppingCart.all
  end

  # GET /shopping_carts/1
  # GET /shopping_carts/1.json
  def show
  end

  # GET /shopping_carts/new
  def new
    @shopping_cart = ShoppingCart.new
  end

  # GET /shopping_carts/1/edit
  def edit
  end

  # POST /shopping_carts
  # POST /shopping_carts.json
  def create

    @quantity = params[:quantity]
	  @listing = Listing.find(params[:listing_id])

    if(@quantity.empty?)
      @quantity = 1
    end


		@shopping_cart.add(@listing, @listing.price, @quantity)
		
    respond_to do |format|
      if @shopping_cart.save
        format.html { redirect_to listings_path, notice: 'Product added to cart.' }
        format.json { render :show, status: :created, location: @shopping_cart }
      else
        format.html { render :new }
        format.json { render json: @shopping_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shopping_carts/1
  # PATCH/PUT /shopping_carts/1.json
  def update
    respond_to do |format|
      if @shopping_cart.update(shopping_cart_params)
        format.html { redirect_to @shopping_cart, notice: 'Shopping cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @shopping_cart }
      else
        format.html { render :edit }
        format.json { render json: @shopping_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_carts/1
  # DELETE /shopping_carts/1.json
  def destroy
    @shopping_cart.destroy
    reset_session
    respond_to do |format|
      format.html { redirect_to listings_path, notice: 'Shopping cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart
      @shopping_cart = ShoppingCart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shopping_cart_params
      params[:shopping_cart]
    end

	def extract_shopping_cart
		shopping_cart_id = session[:shopping_cart_id]
		@shopping_cart = session[:shopping_cart_id] ? ShoppingCart.find(shopping_cart_id) : ShoppingCart.create
		session[:shopping_cart_id] = @shopping_cart.id
	end
end
