require 'rubygems'
require 'roo'

Area.destroy_all
oo = Roo::Spreadsheet.open("script/dealer_data.xlsx")
oo.default_sheet = oo.sheets.first
2.upto(oo.last_row) do |line|
	city_name = oo.cell(line,'A').strip
	city = City.where(:name => city_name).first
	area_name =  oo.cell(line,'B').strip
	city.areas.find_or_initialize_by_name(area_name)
	city.save
end
