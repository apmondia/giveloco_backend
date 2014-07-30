# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create(
	:role => 'admin',
    :first_name => "Taliflo",
    :last_name => "Admin",
    :email => "ben@taliflo.com",
    :password => "password"
)
admin.skip_confirmation!
admin.save!

puts "#{'*'*(`tput cols`.to_i)}\nSuper Admin created!\n"