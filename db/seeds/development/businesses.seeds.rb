require 'faker'

@num = 15

@num.times do
	User.create(
		:role => User::Roles::ROLES[2],
		:first_name => Faker::Name.first_name,
        :last_name => Faker::Name.last_name,
        :company_name => Faker::Company.name,
        :email => Faker::Internet.email,
        :password => "password",
        :street_address => Faker::Address.street_address,
        :city => Faker::Address.city,
        :state => Faker::Address.state,
        :country => ["CA", "US"].shuffle[0],
        :zip => Faker::Address.zip,
        :tags => Faker::Lorem.words(rand(1...10)),
        :summary => Faker::Lorem.sentences(1).join(" "),
        :description => Faker::Lorem.paragraphs(2).join(" "),
        :website => Faker::Internet.url('http://www.example.com'),
        :balance => rand(0.00...5000.00),
        :total_debits => rand(40),
        :total_debits_value => rand(0.00...5000.00),
        :total_credits => rand(40),
        :total_credits_value => rand(0.00...5000.00),
        :is_featured => [true, false].sample,
        :supporters => (0...20).sort_by{rand}[0..rand(20)],
        :supported_causes => (0...20).sort_by{rand}[0..rand(20)],
        :vouchers => (0...20).sort_by{rand}[0..rand(20)],
        :transactions => (0...20).sort_by{rand}[0..rand(20)],
        :redemptions => (0...20).sort_by{rand}[0..rand(20)]
	)
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} businesses created!\n"