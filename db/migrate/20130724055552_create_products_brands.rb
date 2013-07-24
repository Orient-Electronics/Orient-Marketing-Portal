class CreateProductsBrands < ActiveRecord::Migration
  def up
    create_table :brands_products, :id => false do |t|
      t.integer :product_id
      t.integer :brand_id
    end

    add_index :brands_products, [:product_id, :brand_id]
  end

  def down
    drop_table :brands_products
  end
end
