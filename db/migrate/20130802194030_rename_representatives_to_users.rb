class RenameRepresentativesToUsers < ActiveRecord::Migration
  def up
    rename_table :representatives, :users
    rename_column :reports, :representative_id, :user_id
  end

  def down
    rename_table :users, :representatives
    rename_column :reports, :user_id, :representative_id
  end
end
