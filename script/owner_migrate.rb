owners = Owner.all
owners.each do |owner|
	shop = Shop.where(id: owner.shop_id).first
	people = shop.peoples.build(designation: "Owner", name: owner.name, date_of_birth: owner.dob, cell_number: owner.cell_number)
	people.build_avatar
	shop.save
end