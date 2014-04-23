class AddViewAnnouncementToUsers < ActiveRecord::Migration
  def change
    add_column :users, :view_announcement, :boolean, :default => true
  end
end
