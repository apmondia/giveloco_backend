@num = 30

@num.times do
        user = User.create do |u|
                u.role = User::Roles::ROLES[3]
                u.first_name = Faker::Name.first_name
                u.last_name = Faker::Name.last_name
                u.company_name = Faker::Company.name
                u.email = Faker::Internet.email
                u.password = "password"
                u.phone = Faker::Base.numerify('(604)###-####')
                u.street_address = Faker::Address.street_address
                u.city = Faker::Address.city
                u.state = Faker::Address.state
                u.country = ["CA", "US"].shuffle[0]
                u.zip = Faker::Address.zip
                u.tag_list = Faker::Lorem.words(rand(1...10)) # acts_as_taggable_on: renders as "tags" field in JSON
                u.summary = Faker::Lorem.sentences(3).join(" ")
                u.description = Faker::Lorem.paragraphs(2).join(" ")
                u.website = Faker::Internet.url('http://www.example.com')
                u.balance = rand(0.00...5000.00)
                u.total_debits = rand(0...40)
                u.total_debits_value = rand(0.00...5000.00)
                u.total_credits = rand(0...40)
                u.total_credits_value = rand(0.00...5000.00)
                u.is_featured = [true, false].sample
                u.supporters = []
                u.confirmed_at = DateTime.now
                u.skip_confirmation!
                u.skip_confirmation_notification!
                u.save!
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} causes created!\n"