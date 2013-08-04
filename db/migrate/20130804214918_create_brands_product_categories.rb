class CreateBrandsProductCategories < ActiveRecord::Migration
  def up
    create_table :brands_product_categories, :id => false do |t|
      t.integer :product_category_id
      t.integer :brand_id
    end

  end

  def down
    drop_table :brands_product_categories
  end
end
