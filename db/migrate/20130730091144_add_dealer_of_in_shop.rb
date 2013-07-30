class AddDealerOfInShop < ActiveRecord::Migration
  def change
    remove_column :shops, :branch_of
    add_column :shops, :dealer_id, :integer
  end
end
