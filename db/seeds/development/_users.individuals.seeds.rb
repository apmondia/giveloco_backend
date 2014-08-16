@num = 30

@num.times do
        user = User.create do |u|
                u.role = User::Roles::ROLES[1]
                u.first_name = Faker::Name.first_name
                u.last_name = Faker::Name.last_name
                u.email = Faker::Internet.email
                u.password = "password"
                u.balance = rand(0.00...5000.00)
                u.total_debits = rand(0...40)
                u.total_debits_value = rand(0.00...5000.00)
                u.total_credits = rand(0...40)
                u.total_credits_value = rand(0.00...5000.00)
                u.confirmed_at = DateTime.now
                u.skip_confirmation!
                u.skip_confirmation_notification!
                u.save!
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} people created!\n"