class AddStatusToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :status, :string, :default => 'unread'
  end
end
