class ShoppingCart < ActiveRecord::Base
	  acts_as_shopping_cart

	  belongs_to :order
end
