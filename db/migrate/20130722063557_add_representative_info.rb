class AddRepresentativeInfo < ActiveRecord::Migration
  def change
    add_column :representatives, :first_name, :string
    add_column :representatives, :last_name, :string
    add_column :representatives, :phone_number, :integer
  end
end
