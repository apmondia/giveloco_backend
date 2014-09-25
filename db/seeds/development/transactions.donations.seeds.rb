@num = 60

@num.times do
        donation = Transaction.create do |t|
                t.from_user_id = rand(62...91)
                t.to_user_id = rand(32...61)
                t.amount = rand(0.00...100.00)
                t.status = Transaction::Status::STATUS[2]
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Donations created!\n"