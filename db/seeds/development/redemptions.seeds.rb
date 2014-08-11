require 'faker'

@num = 20

@num.times do
        donation = Redemption.create do |r|
                r.voucher_id = rand(1...20)
                r.vendor_id = rand(2...31)
                r.redeemed_by_id = rand(62...91)
                r.redeemer_name = Faker::Name.name
                r.vendor_name = Faker::Company.name
                r.value = rand(0.00...100.00)
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Redemptions created!\n"