class AddWeekCol < ActiveRecord::Migration
  def up
    add_column :reports, :week, :integer   
  end

  def down
    remove_column :reports, :week
  end
end
