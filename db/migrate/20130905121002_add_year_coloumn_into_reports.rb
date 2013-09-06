class AddYearColoumnIntoReports < ActiveRecord::Migration
  def up
    add_column :reports, :year, :integer
  end

  def down
    remove_column :reports, :year
  end
end
