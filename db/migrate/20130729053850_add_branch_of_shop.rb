class AddBranchOfShop < ActiveRecord::Migration
  def change
    add_column :shops, :branch_of, :string
  end
end
