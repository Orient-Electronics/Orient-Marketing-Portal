class ReportForProductCategory < ActiveRecord::Migration
  def change
    add_column :report_lines, :product_category_id, :integer
  end
end
