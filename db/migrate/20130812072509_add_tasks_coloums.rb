class AddTasksColoums < ActiveRecord::Migration
  def up
    add_column :tasks, :assigned_by, :integer
    add_column :tasks, :assigned_to, :integer
    add_column :tasks, :comment,     :text
    add_column :tasks, :shop_id,     :integer
    add_column :tasks, :status,      :string, :default => "pending"

  end

  def down
    remove_column :tasks, :assigned_by
    remove_column :tasks, :assigned_to
    remove_column :tasks, :comment
    remove_column :tasks, :shop_id
    remove_column :tasks, :status
  end
end
