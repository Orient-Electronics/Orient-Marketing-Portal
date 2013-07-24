class CreateProductsBrands < ActiveRecord::Migration
  def up
    create_table :products_brands, :id => false do |t|
      t.integer :product_id
      t.integer :brand_id
    end

    add_index :products_brands, [:product_id, :brand_id]
  end

  def down
    drop_table :products_brands
  end
end
