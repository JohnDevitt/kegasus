class Depot < ActiveRecord::Base

	geocoded_by :full_address
	after_validation :geocode

	has_many :routes

	def full_address
		[address, "Ireland"].compact.join(', ')
	end
end
