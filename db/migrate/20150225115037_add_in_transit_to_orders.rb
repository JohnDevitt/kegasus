class AddInTransitToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :in_transit, :boolean
  end
end
