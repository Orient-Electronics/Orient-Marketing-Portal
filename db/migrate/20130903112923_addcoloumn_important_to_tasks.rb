class AddcoloumnImportantToTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :important, :boolean
  end

  def down
    remove_column :tasks, :important
  end
end
