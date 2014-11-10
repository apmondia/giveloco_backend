# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create do |u|
	u.role = User::Roles::ROLES[0]
    u.first_name = "Taliflo"
    u.last_name = "Admin"
    u.email = "ben@taliflo.com"
    u.password = "password"
    u.company_name = "Taliflo Inc."
    u.website = "http://www.taliflo.com"
    u.street_address = nil
    u.country = "Canada"
    u.state = "BC"
    u.zip = nil
    u.phone = nil
    u.tag_list = nil
    u.description = nil
    u.summary = nil
    u.confirmed_at = DateTime.now
	  u.skip_confirmation!
    u.skip_confirmation_notification!
    u.save!
end

puts "#{'*'*(`tput cols`.to_i)}\nSuper Admin created!\n"