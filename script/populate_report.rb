require 'rubygems'

reports = Report.all.group_by {|d| d.year and d.week and d.user_id and d.shop_id and (d.report_lines.first.product_id or d.report_lines.first.product_category_id) }

reports.collect do |key, report|
	display_reports =  report.select{|a| a.report_type == "display"}
	sale_reports    =  report.select{|a| a.report_type == "sales"}
	corner_reports  = 	report.select{|a| a.report_type == "display_corner"}
	
	corner_reports.each_with_index do |display_corner,index|
		sale = sale_reports[index]
		display = display_reports[index]
		if sale.post_id.nil? and display.post_id? and display_corner.post_id?
			post = Post.new :shop_id => display_corner.shop_id, :dealer_id => display_corner.shop.dealer.id, :product_category_id => display_corner.report_lines.first.id, :user_id => display_corner.user.id  
			post.save
			sale.post_id = display.post_id = display_corner.post_id = post.id
			sale.save
			display.save
			display_corner.save
		end
	end
end