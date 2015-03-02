class AddOrdersAssociationToRoute < ActiveRecord::Migration
  def self.up
      add_column :orders, :route_id, :integer
      add_index 'orders', ['route_id'], :name => 'index_route_id' 
  end

  def self.down
      remove_column :orders, :route_id
  end
end
