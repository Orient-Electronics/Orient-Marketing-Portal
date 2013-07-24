# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Brand.delete_all
Brand.create([ { name: 'Samsung' },  { name: 'Sony' },   { name: 'LG' },  { name: 'Panasonic' },  { name: 'Haier' },  { name: 'Ecostar' },  { name: 'Changhong' },  { name: 'Orient' },  { name: 'Gree' },  { name: 'Kenwood' },  { name: 'Electrolux' },  { name: 'Galanz' },  { name: 'Dawlance' },  { name: 'Waves' },  { name: 'Mitsubishi' },  { name: 'Changhong' },  { name: 'PEL' },  { name: 'Other' }])
