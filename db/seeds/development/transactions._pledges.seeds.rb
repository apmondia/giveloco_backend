@num = 60

@num.times do
        pledge = Transaction.create do |t|
                t.from_user_id = rand(2...31)
                t.to_user_id = rand(32...61)
                # t.amount = rand(0.00...5000.00)
                t.amount = 20
                t.status = Transaction::Status::STATUS[rand(0...3)]
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Pledges created!\n"