class Listing < ActiveRecord::Base

	  enum categories: [:beer, :wine, :spirits, :soft_drinks, :party_food]
	  if Rails.env.development?
	  	has_attached_file :image, :styles => { :medium => "200x200", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	  else
	  has_attached_file :image, :styles => { :medium => "200x200", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png",
	  							:storage => :dropbox,
    							:dropbox_credentials => Rails.root.join("config/dropbox.yml")
   		end
	  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	  has_many :orders

	  self.per_page = 8

	  filterrific(
	  	default_settings: { sorted_by: 'price_asc' },
    	filter_names: [
      		:search_query,
      		:sorted_by,
      		:max_price,
      		:filtered_by
    	]
  	  )

  	  scope :search_query, lambda { |query|
		  # Searches the students table on the 'first_name' and 'last_name' columns.
		  # Matches using LIKE, automatically appends '%' to each term.
		  # LIKE is case INsensitive with MySQL, however it is case
		  # sensitive with PostGreSQL. To make it work in both worlds,
		  # we downcase everything.
		  return nil  if query.blank?

		  # condition query, parse into individual keywords
		  terms = query.downcase.split(/\s+/)

		  # replace "*" with "%" for wildcard searches,
		  # append '%', remove duplicate '%'s
		  terms = terms.map { |e|
		    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
		  }
		  # configure number of OR conditions for provision
		  # of interpolation arguments. Adjust this if you
		  # change the number of OR conditions.
		  num_or_conds = 1
		  where(
    	  terms.map { |term|
      		"(LOWER(listings.name) LIKE ?)"
    	  }.join(' AND '),
    	  *terms.map { |e| [e] * num_or_conds }.flatten)
	  }

	  scope :filtered_by, lambda { |filter_category|
	  	if filter_category != "ALL"
	  		where(category: [*filter_category])
	  	end
	  }

	  scope :max_price, lambda { |max_price|
		  where('listings.price <= ?', max_price)
	  }

	  scope :sorted_by, lambda { |sort_option|
	  	direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
	  	case sort_option.to_s
	  	when /^created_at_/
	  		order("listings.created_at #{ direction }")
	  	when /^price_/
	  		order("listings.price #{direction }")
	  	when /^volume_/
	  		order("listings.volume #{direction }")
	  	when /^percentage_/
	  		order("listings.abv #{direction }")
	  	when /^buzz_for_buck_/
	  		order("listings.volume * abv / 100 / price #{direction }")
	  	else
    		raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  		end
	  }


	  def self.options_for_sorted_by
		[
			['Price', 'price_asc'],
			['Volume', 'volume_desc'],
			['Percentage', 'percentage_asc'],
			['Buzz For Buck', 'buzz_for_buck_asc']
		]
	  end

	  def self.options_for_filtered_by
		[
			['All', 'ALL'],
			['Beer', '0'],
			['Wine', '1'],
			['Spirits', '2'],
			['Soft Drinks', '3'],
			['Party Food', '4']
		]
	  end
end
