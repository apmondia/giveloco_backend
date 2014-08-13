@num = 50

@num.times do
        donation = Voucher.create do |v|
                v.issued_by_id = rand(32...61)
                v.claimed_by_id = rand(62...91)
                v.issued_by_name = Faker::Company.name
                v.claimed_by_name = Faker::Name.name
                v.max_value = rand(0.00...500.00)
                v.redeemed = [true, false].sample
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Vouchers created!\n"