class CreatePeopleShops < ActiveRecord::Migration
  def change
    create_table :people_shops do |t|
      t.integer :shop_id
      t.integer :people_id

      t.timestamps
    end
  end
end
