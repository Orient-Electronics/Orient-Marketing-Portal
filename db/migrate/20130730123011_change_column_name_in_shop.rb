class ChangeColumnNameInShop < ActiveRecord::Migration
  def change
    remove_column :shops, :dealer
    add_column :shops, :orient_dealer, :boolean, :default => false
  end
end
