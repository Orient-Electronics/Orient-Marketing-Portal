class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :name
      t.integer :cell_number
      t.date :dob
      t.integer :shop_id

      t.timestamps
    end
  end
end
