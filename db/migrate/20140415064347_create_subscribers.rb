class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.integer :user_id
      t.integer :subscribe_id

      t.timestamps
    end
  end
end
