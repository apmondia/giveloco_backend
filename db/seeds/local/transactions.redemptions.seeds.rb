@num = 60

@num.times do
        redemption = Transaction.create do |t|
                t.trans_type = Transaction::Type::TYPE[2]
                t.from_user_id = rand(62...91)
                t.to_user_id = rand(2...31)
                t.amount = rand(0.00...50.00)
                t.status = Transaction::Status::STATUS[rand(0...3)]
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Redemptions created!\n"