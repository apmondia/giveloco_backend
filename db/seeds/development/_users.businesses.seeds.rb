@num = 30

@num.times do
        email = Faker::Internet.email
        company = Faker::Company.name
        user = User.where(:email => email ).first_or_create do |u|
                u.role = User::Roles::ROLES[2]
                u.first_name = Faker::Name.first_name
                u.last_name = Faker::Name.last_name
                u.company_name = company
                u.email = email
                u.password = "password"
                u.phone = Faker::Base.numerify('(604)###-####')
                u.street_address = Faker::Address.street_address
                u.city = Faker::Address.city
                u.state = Faker::Address.state_abbr
                u.country = ["Canada", "United States"].shuffle[0]
                u.zip = Faker::Address.zip
                u.tag_list = Faker::Lorem.words(rand(1...10)) # acts_as_taggable_on: renders as "tags" field in JSON
                u.summary = Faker::Lorem.sentences(3).join(" ")
                u.description = Faker::Lorem.paragraphs(2).join(" ")
                u.website = Faker::Internet.url('www.example.com')
                u.is_featured = [true, false].sample
                u.is_published = [true, false].sample
                u.is_activated = [true, false].sample
                u.confirmed_at = DateTime.now
                u.skip_confirmation!
                u.skip_confirmation_notification!
                u.save!
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} businesses created!\n"