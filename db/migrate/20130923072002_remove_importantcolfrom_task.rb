class RemoveImportantcolfromTask < ActiveRecord::Migration
  def up
    remove_column :tasks, :important
  end

  def down
    add_column :tasks, :important, :boolean
  end
end
