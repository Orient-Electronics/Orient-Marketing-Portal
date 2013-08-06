require 'rubygems'
require 'roo'

f = {}
Brand.all.collect{|b| f[b.name] = b.id}
pc={}
ProductCategory.all.collect{|b| f[b.name] = b.id}
p = {}
Product.all.collect{|b| f[b.name] = b.id}
oo = Roo::Spreadsheet.open("script/mapping_sample.xlsx")
oo.default_sheet = oo.sheets.first
2.upto(oo.last_row) do |line|
  shop = Shop.new
  location = Location.new
  owner = Owner.new
  manager = Manager.new
  location.city = City.find_by_name(oo.cell(line,'B').strip)
  location.area   = oo.cell(line,'C')
  shop.dealer_name      = oo.cell(line,'D')
  shop.branch_of    = oo.cell(line,'E')
  shop.address    = oo.cell(line,'F')
  shop.phone    = oo.cell(line,'G')
  shop.website    = oo.cell(line,'H')
  shop.email    = oo.cell(line,'I')
  location.latitude    = oo.cell(line,'J')
  location.longitude    = oo.cell(line,'K')
  owner.name    = oo.cell(line,'L')
  owner.cell_number    = oo.cell(line,'M')
  owner.dob    = oo.cell(line,'N')
  manager.name    = oo.cell(line,'O')
  manager.cell_number    = oo.cell(line,'P')
  manager.dob    = oo.cell(line,'Q')
  shop.orient_dealer    = oo.cell(line,'R').strip.capitalize == 'Yes' ? true : false
  shop.shop_category    = ShopCategory.find_by_name(oo.cell(line,'S').strip)

  letter = 'S'

  if shop.save
    location.shop = shop
    location.save
    owner.shop = shop
    owner.save
    manager.shop = shop
    manager.save
    p shop

    sales_report = Report.create :report_type => "sales", :shop_id => shop.id
    display_report = Report.create :report_type => "display", :shop_id => shop.id
    corner_report = Report.create :report_type => "display_corner", :shop_id => shop.id

    ref1 = []
    ref2 = []
    ref3 = []
    product = ProductCategory.find_by_name("Refrigerator")
    ref=["Dawlance","PEL","Orient", "Haier", "Waves", "Other"]
    ref.each do |brand|
      ref1.push(product.report_lines.build :brand_id => f[brand],:report_id => sales_report.id)
      ref2.push(product.report_lines.build :brand_id => f[brand],:report_id => display_report.id)
      ref3.push(product.report_lines.build :brand_id => f[brand],:report_id => corner_report.id)
    end


    ac1 = []
    ac2 = []
    ac3 = []
    product = ProductCategory.find_by_name("Air Conditioner")
    ac = ["Orient","Haier","Dawlance","Electrolux","Galanz","PEL","Gree","Kenwood","LG","Mitsubishi","Panasonic","Changhong","Samsung","Other"]
    ac.each do |brand|
      ac1.push(product.report_lines.build :brand_id => f[brand],:report_id => sales_report.id)
      ac2.push(product.report_lines.build :brand_id => f[brand],:report_id => display_report.id)
      ac3.push(product.report_lines.build :brand_id => f[brand],:report_id => corner_report.id)
    end


    lcd1 = []
    lcd2 = []
    lcd3 = []
    product = Product.find_by_name("LCD")
    lcd=["Samsung","Sony","LG","Panasonic","Haier","Ecostar","Changhong","Orient","Other"]
    lcd.each do |brand|
      lcd1.push(product.report_lines.build :brand_id => f[brand],:report_id => sales_report.id)
      lcd2.push(product.report_lines.build :brand_id => f[brand],:report_id => display_report.id)
      lcd3.push(product.report_lines.build :brand_id => f[brand],:report_id => corner_report.id)
    end


    led1 = []
    led2 = []
    led3 = []
    product = Product.find_by_name("LED")
    led=["Samsung","Sony","LG","Panasonic","Haier","Ecostar","Changhong","Orient","Other"]
    led.each do |brand|
      led1.push(product.report_lines.build :brand_id => f[brand],:report_id => sales_report.id)
      led2.push(product.report_lines.build :brand_id => f[brand],:report_id => display_report.id)
    end


    pdp1 = []
    pdp2 = []
    pdp3 = []
    product = Product.find_by_name("PDP")
    pdp=["Samsung","Sony","LG","Panasonic","Haier"]
    pdp.each do |brand|
      pdp1.push(product.report_lines.build :brand_id => f[brand],:report_id => sales_report.id)
      pdp2.push(product.report_lines.build :brand_id => f[brand],:report_id => display_report.id)
    end

    ref1.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    ac1.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    lcd1.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    led1.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    pdp1.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    ref2.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    ac2.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    lcd2.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    led2.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    pdp2.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter)
      rline.save
    end
    ref3.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter).strip.capitalize == 'Yes' ? 1 : 0
      rline.save
    end
    ac3.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter).strip.capitalize == 'Yes' ? 1 : 0
      rline.save
    end
    lcd3.each do |rline|
      letter = letter.next
      rline.data = oo.cell(line,letter).strip.capitalize == 'Yes' ? 1 : 0
      rline.save
    end

  end
end