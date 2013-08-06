# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Brand.delete_all
Brand.create([ { name: 'Samsung' },  { name: 'Sony' },   { name: 'LG' },  { name: 'Panasonic' },  { name: 'Haier' },  { name: 'Ecostar' },  { name: 'Changhong' },  { name: 'Orient' },  { name: 'Gree' },  { name: 'Kenwood' },  { name: 'Electrolux' },  { name: 'Galanz' },  { name: 'Dawlance' },  { name: 'Waves' },  { name: 'Mitsubishi' },  { name: 'Changhong' },  { name: 'PEL' },  { name: 'Other' }])

City.delete_all
City.create([ { name: 'Abbottabad' },  { name: 'Ahmed Pur' },   { name: 'Battagram' },  { name: 'Bhawalpur' },  { name: 'Biriya Road' },  { name: 'Daharki' },  { name: 'Dina' },  { name: 'Dor' },  { name: 'Faisalabad' },  { name: 'Firoza' },  { name: 'Gambat' },  { name: 'Muridke' },  { name: 'Ghakhar Mandi' },  { name: 'Ghotki' },  { name: 'Gujjar Khan' },  { name: 'Gujranwala' },  { name: 'Gujrat' },  { name: 'Hafizabad' },  { name: 'Haripur' },  { name: 'Hasilpur' },  { name: 'Hyderabad' },  { name: 'Islamabad' },  { name: 'Jauharabad' },  { name: 'Jehlum' },  { name: 'Kamoki' },  { name: 'Kandiaro' },  { name: 'Karachi' },  { name: 'Kasur' },  { name: 'Khairpur' },  { name: 'Khairpur Tamewali' },  { name: 'Khan Pur' },  { name: 'Lahore' },  { name: 'Lalamusa' },  { name: 'Larkana' },  { name: 'Liaqatpur' },  { name: 'Lodhran' },  { name: 'Multan' },  { name: 'Mansehra' },  { name: 'Mehrabpur' },  { name: 'Mir Pur Mathelo' },  { name: 'Mirpur Khas' },  { name: 'Moro' },  { name: 'Muzaffarabad' },  { name: 'Nawabshah' },  { name: 'Obaro' },  { name: 'Panun Aaql' },  { name: 'Peshawar' },  { name: 'Rahim Yar Khan' },  { name: 'Sheikhupura' },  { name: 'Ranipur' },  { name: 'Rawalpindi' },  { name: 'Sadiqabad' },  { name: 'Sahiwal' },  { name: 'Sanghar' },  { name: 'Sargodha' },  { name: 'Shahdadpur' },  { name: 'Sialkot' },  { name: 'Sukkur' },  { name: 'Swat' },  { name: 'Tando Adam' },  { name: 'Yazman' }])

ShopCategory.delete_all
ShopCategory.create([ { name: 'Dawlance Exclusive' },  { name: 'Dawlance USL' },   { name: 'Haier Exclusive'},  { name: 'LG Concept Shop' },  { name: 'Multi Brand Shop' },  { name: 'Orient Center' },  { name: 'Orient Exclusive' },  { name: 'PEL Exclusive' },  { name: 'Ruba Digital' },  { name: 'Samsung Brand Shop' },  { name: 'Samsung Concept Shop' },  { name: 'Seasonal Electronics Shop' },  { name: 'Singer Plus' },  { name: 'Sony Center' },  { name: 'Sony World' }])

f = {}
Brand.all.collect{|b| f[b.name] = b.id.to_s}

ProductCategory.delete_all
ProductCategory.create([ { name: 'Air Conditioner', brand_ids: ["", f["Dawlance"], f["PEL"], f["Orient"], f["Haier"], f["Other"],f["Electrolux"], f["Galanz"], f["Gree"], f["Kenwood"], f["LG"], f["Mitsubishi"], f["Panasonic"], f["Changhong"], f["Samsung"]] },
 { name: 'Microwave Oven' }, {name: 'Refrigerator', brand_ids: ["", f["Dawlance"], f["PEL"], f["Orient"], f["Haier"], f["Waves"], f["Other"]]},
  {name: 'Vacuum Cleaner'}, {name: 'Washing Machine'}, {name: 'Water Dispenser'}])
p={}
ProductCategory.all.collect{|b| p[b.name] = b.id.to_s}

Product.delete_all
Product.create([{name: 'LCD',brand_ids: ["", f["Samsung"], f["Sony"], f["Orient"], f["Haier"], f["Changhong"], f["Other"],f["Ecostar"], f["Panasonic"],f["LG"]]},
{name: 'LED', brand_ids: ["", f["Samsung"], f["Sony"], f["Orient"], f["Haier"], f["Changhong"], f["Other"],f["Ecostar"], f["Panasonic"],f["LG"]]},
{name: 'PDP', brand_ids: ["", f["Samsung"], f["Sony"], f["LG"], f["Haier"], f["Panasonic"]]}
  ])