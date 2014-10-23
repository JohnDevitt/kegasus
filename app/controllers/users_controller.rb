class UsersController < ApplicationController

	def index
		puts "----------------------------------------------------------------------------------------"
		puts @orders = Order.where(user_id: current_user.id).take
		puts "----------------------------------------------------------------------------------------"
	end

	def show
		puts "----------------------------------------------------------------------------------------"
		puts @orders = Order.where(user_id: current_user.id)
		puts "----------------------------------------------------------------------------------------"
	end

	def orders
		
	end

end
