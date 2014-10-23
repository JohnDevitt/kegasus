class AddShoppingCartIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shopping_cart_id, :string
    add_column :orders, :integer, :string
  end
end
