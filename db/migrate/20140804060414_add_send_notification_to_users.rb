class AddSendNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_notification, :boolean, :default => true
  end
end
