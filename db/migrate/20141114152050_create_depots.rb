class CreateDepots < ActiveRecord::Migration
  def change
    create_table :depots do |t|
      t.float :latitude
      t.float :longitude
      t.string :address

      t.timestamps
    end
  end
end
