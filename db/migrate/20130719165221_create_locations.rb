class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :city_id
      t.string :area
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
