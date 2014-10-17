@num = 60

@num.times do
        redemption = Transaction.create do |t|
                t.from_user_id = rand(62...91)
                t.to_user_id = rand(2...31)
                # t.amount = rand(0.00...50.00)
                t.amount = 20
				# t.status = Transaction::Status::STATUS[rand(0...3)]
                t.status = "pending"
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Redemptions created!\n"

updateTrans = Transaction.where({:trans_type => "redemption"})
updateTrans.each do |t|
	t.update_attributes(:status => Transaction::Status::STATUS[rand(0...3)])
	# puts "To User Balance: #{t.to_user_balance}"
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Redemptions updated!\n"