after 'development:sponsorship', 'development:_users.individuals' do

  @num = rand(4)
  @sponsors = Sponsorship.all.count

  Sponsorship.all.each do |sponsorship|

    @num.times do

      @purchaser = User.where(:role => 'individual').to_a.sample

      c = Certificate.create({
          :purchaser => @purchaser,
          :sponsorship => sponsorship,
          :amount => 20.00,
          :donation_percentage => 20,
          :recipient => @purchaser.email
      })

    end

  end

  puts "#{'*'*(`tput cols`.to_i)}\n#{@num*@sponsors} certificates created!\n"

end