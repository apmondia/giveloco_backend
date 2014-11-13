after 'development:_users.businesses', 'development:_users.causes' do

  index = 0

  User.where(:role => 'business').each do |business|
    puts "Business with id #{business.id} is invalid: #{business.valid?}"
    causes = User.where(:role => 'cause').limit(3).offset(index)
    index += 3

    causes.each do |cause|
      sponsorship = Sponsorship.create({
                                           :business => business,
                                           :cause => cause,
                                       })
      if cause.id % 2 == 0 #arbitrary pseudo randomness
        sponsorship.accepted!
        sponsorship.resolved_at = DateTime.now
      end

      if !sponsorship.save
        puts sponsorship.errors.full_messages
      end
    end
  end
end