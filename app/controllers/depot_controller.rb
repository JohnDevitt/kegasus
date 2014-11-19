class DepotController < ApplicationController
  def addDepot
  end

  def create

    puts "-------------------------"
    puts params[:depot][:address]
    puts "-------------------------"

      @depot = Depot.new(depot_params)
      if @depot.save
            redirect_to :action => 'addDepot'
      else
            render :action => 'addDepot'
      end
   end

   private
    # Never trust parameters from the scary internet, only allow the white list through.
    def depot_params
      params.require(:depot).permit(:address)
    end
end
