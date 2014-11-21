class FixListingsVolumeAbvAndCategory < ActiveRecord::Migration
  def change
  	rename_column :listings, :type, :category
	rename_column :listings, :Volume, :volume
	rename_column :listings, :ABV, :abv
  end
end
