class Order < ActiveRecord::Base

	belongs_to :user
	has_one :shopping_cart
end
