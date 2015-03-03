class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]


  # GET /listings
  # GET /listings.json
  def index

    user = User.find(1)
    user.admin = true
    user.save

    @filterrific = Filterrific.new(Listing, params[:filterrific]  || session[:filterrific_listings])

    @filterrific.select_options = {
      sorted_by: Listing.options_for_sorted_by,
      filtered_by: Listing.options_for_filtered_by
    }

    @listings = Listing.filterrific_find(@filterrific).page(params[:page])


    session[:filterrific_listings] = @filterrific.to_hash

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_listings] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:name, :description, :price, :image, :volume, :abv, :category)
    end
end
