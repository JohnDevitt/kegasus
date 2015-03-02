class AddAssociationRoutesToDepot < ActiveRecord::Migration
  def self.up
      add_column :routes, :depot_id, :integer
      add_index 'routes', ['depot_id'], :name => 'index_depot_id' 
  end

  def self.down
      remove_column :routes, :depot_id
  end
end
