class AddPostIdReport < ActiveRecord::Migration
  def change
  	add_column :reports, :post_id, :integer
  end
end
