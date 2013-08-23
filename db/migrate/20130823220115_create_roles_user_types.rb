class CreateRolesUserTypes < ActiveRecord::Migration
  def change
    create_table :roles_user_types do |t|
      t.integer :user_type_id
      t.integer :role_id

      t.timestamps
    end
  end
end
