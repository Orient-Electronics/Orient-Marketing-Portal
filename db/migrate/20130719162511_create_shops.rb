class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :dealer_name
      t.integer :phone
      t.string :website
      t.string :email
      t.string :address
      t.boolean :dealer
      t.integer :shop_category_id
      t.integer :location_id

      t.timestamps
    end
  end
end
