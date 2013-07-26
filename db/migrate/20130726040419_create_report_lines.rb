class CreateReportLines < ActiveRecord::Migration
  def change
    create_table :report_lines do |t|
      t.integer :report_id
      t.integer :product_id
      t.integer :brand_id
      t.integer :data

      t.timestamps
    end
  end
end
