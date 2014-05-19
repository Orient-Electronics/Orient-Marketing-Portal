class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.integer :cell_number
      t.datetime :date_of_birth
      t.string :designation

      t.timestamps
    end
  end
end
