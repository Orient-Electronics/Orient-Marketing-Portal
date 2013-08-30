class RemoveStartDateCol < ActiveRecord::Migration
  def change
    remove_column :reports, :start_at, :end_at   
  end
end
