require 'faker'

@num = 60
@count = 0

@num.times do
        @count += 1
        donation = Transaction.create do |t|
                t.created_by_id = rand(62...91)
                t.accepted_by_id = rand(32...61)
                t.trans_id = @count # 1-60
                t.trans_type = Transaction::Type::TYPE[1]
                t.from_name = Faker::Name.name 
                t.to_name = Faker::Company.name
                t.total_debt = rand(0.00...5000.00)
                t.total_credit = rand(0.00...5000.00)
                t.remaining_debt = t.total_credit - t.total_debt
                t.status = Transaction::Status::STATUS[rand(0...1)]
                t.active = [true, false].sample
        end
end

puts "#{'*'*(`tput cols`.to_i)}\n#{@num} Donations created!\n"