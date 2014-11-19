class Depot < ActiveRecord::Base

	geocoded_by :full_address
	after_validation :geocode

	def full_address
		[address, "Ireland"].compact.join(', ')
	end
end
