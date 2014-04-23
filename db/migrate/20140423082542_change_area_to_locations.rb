class ChangeAreaToLocations < ActiveRecord::Migration
  def change
  	rename_column :locations, :area, :area_id
  	change_column :locations, :area_id, :integer
  end
end
