class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :symbol
      t.text :notes
      t.string :action
      t.string :entity

      t.timestamps
    end
  end
end
