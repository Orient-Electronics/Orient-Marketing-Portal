class AddTaskTypeAtTask < ActiveRecord::Migration
  def up
    add_column :tasks, :task_type, :string, :default => 'report' 
  end

  def down
    remove_column :tasks, :task_type
  end
end
