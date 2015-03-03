class Order < ActiveRecord::Base

	belongs_to :route
	belongs_to :user
	has_one :shopping_cart

	geocoded_by :full_address

	after_validation :geocode, :if => :address_changed?

	def full_address
		[address, town, county].compact.join(', ')
	end
end
