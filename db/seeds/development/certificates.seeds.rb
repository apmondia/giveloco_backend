after 'development:sponsorship', 'development:_users.individuals' do

  @num = rand(1..5)
  @sponsors = Sponsorship.all.count

  Sponsorship.all.each do |sponsorship|

    @num.times do |i|

      @purchaser = User.where(:role => 'individual').to_a.sample

      c = Certificate.create({
          :purchaser => @purchaser,
          :sponsorship => sponsorship,
          :amount => 20,
          :donation_percentage => 20,
          :recipient => @purchaser.email,
          :serial_number => "#{i}-#{1000 + rand(1234)}"
      })

    end

  end

  puts "#{'*'*(`tput cols`.to_i)}\n#{@num*@sponsors} certificates created!\n"

end