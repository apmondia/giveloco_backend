require 'faker'

@num = 30

@num.times do
        user = User.create do |u|
                u.role = User::Roles::ROLES[2]
                u.first_name = Faker::Name.first_name
                u.last_name = Faker::Name.last_name
                u.company_name = Faker::Company.name
                u.email = Faker::Internet.email
                u.password = "password"
                u.street_address = Faker::Address.street_address
                u.city = Faker::Address.city
                u.state = Faker::Address.state
                u.country = ["CA", "US"].shuffle[0]
                u.zip = Faker::Address.zip
                u.tags = Faker::Lorem.words(rand(1...10))
                u.summary = Faker::Lorem.sentences(3).join(" ")
                u.description = Faker::Lorem.paragraphs(2).join(" ")
                u.website = Faker::Internet.url('http://www.example.com')
                u.balance = rand(0.00...5000.00)
                u.total_debits = rand(0...40)
                u.total_debits_value = rand(0.00...5000.00)
                u.total_credits = rand(0...40)
                u.total_credits_value = rand(0.00...5000.00)
                u.is_featured = [true, false].sample
                u.supported_causes = (0...20).sort_by{rand}[0..rand(20)]
                u.confirmed_at = DateTime.now
                u.skip_confirmation!
                u.skip_confirmation_notification!
                u.save!
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} businesses created!\n"