class AddVolumeAndAbvToListings < ActiveRecord::Migration
  def change
    add_column :listings, :Volume, :integer
    add_column :listings, :ABV, :float
  end
end
