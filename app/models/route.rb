class Route < ActiveRecord::Base
	has_many :orders
	belongs_to :depot

	def gmaps4rails_marker_picture
 {
  "picture" => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=A|123123|000000",          # string,  mandatory
   "width" => 32 ,          # integer, mandatory
   "height" => 32,          # integer, mandatory
 }
end
end
