managers =  Manager.all
managers.each do |manager|
	shop = Shop.where(id: manager.shop_id).first
	people = shop.peoples.build(designation: "Manager", name: manager.name, date_of_birth: manager.dob, cell_number: manager.cell_number)
	people.build_avatar
	shop.save
end