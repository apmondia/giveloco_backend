@num = 60

@num.times do
        donation = Transaction.create do |t|
                @from_id = rand(62...91)
                @to_id = rand(32...61)

                t.trans_type = Transaction::Type::TYPE[1]
                t.from_user_id = @from_id
                t.to_user_id = @to_id
                t.from_name = User.get_user_name(@from_id)
                t.to_name = User.get_user_name(@to_id)
                t.from_user_role = User.get_user_role(@from_id)
                t.to_user_role = User.get_user_role(@to_id)
                t.amount = rand(0.00...100.00)
                t.status = Transaction::Status::STATUS[rand(0...3)]
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Donations created!\n"