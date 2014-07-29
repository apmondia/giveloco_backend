require 'faker'

@num = 30

@num.times do
	User.create(
		:role => User::Roles::ROLES[1],
        :first_name => Faker::Name.first_name,
        :last_name => Faker::Name.last_name,
        :email => Faker::Internet.email,
        :password => "password",
        :balance => rand(0.00...5000.00),
        :total_debits => rand(0...40),
        :total_debits_value => rand(0.00...5000.00),
        :total_credits => rand(0...40),
        :total_credits_value => rand(0.00...5000.00)
	)
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} people created!\n#{'*'*(`tput cols`.to_i)}"