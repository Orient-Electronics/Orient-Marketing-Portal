class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :shop_id
      t.integer :representative_id
      t.string :report_type
      t.datetime :start_at
      t.datetime :end_at
      t.text :data

      t.timestamps
    end
  end
end
