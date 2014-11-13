after 'local:sponsorship' do

  Sponsorship.all.each do |sponsorship|

    rand(4).times do

      c = Certificate.create({
          :purchaser => User.where(:role => 'individual').to_a.sample,
          :sponsorship => sponsorship,
          :amount => 99.90,
          :donation_percentage => 20,
          :recipient => 'bob@fake.com'
      })

    end

  end

end