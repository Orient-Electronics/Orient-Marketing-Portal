class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :shop_id
      t.integer :dealer_id
      t.integer :product_category_id

      t.timestamps
    end
  end
end
