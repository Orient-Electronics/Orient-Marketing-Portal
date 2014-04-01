class AddApprovedIdInToPost < ActiveRecord::Migration
  def up
  	add_column :posts, :approved_id, :integer
  end

  def down
  	remove_column :posts, :approved_id
  end
end
