class CreateActivitySettings < ActiveRecord::Migration
  def change
    create_table :activity_settings do |t|
      t.integer :subscriber_id
      t.string :activity_name
      t.string :activity_type

      t.timestamps
    end
  end
end
