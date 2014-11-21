class AddTypeToListing < ActiveRecord::Migration
  def change
    add_column :listings, :type, :integer
  end
end
