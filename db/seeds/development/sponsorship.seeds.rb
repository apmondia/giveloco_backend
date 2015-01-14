after 'development:_users.businesses', 'development:_users.causes' do

  index = 0
  counter = 0

  User.where(:role => 'business').each do |business|
    #puts "Business with id #{business.id} is valid: #{business.valid?}"
    causes = User.where(:role => 'cause').limit(3).offset(index)
    index += 3

    causes.each do |cause|
      sponsorship = Sponsorship.create({
                                           :business => business,
                                           :cause => cause
                                       })
      if !sponsorship.valid?
        puts "Sponsorship is not valid: #{sponsorship.errors.full_messages}"
      end
      if cause.id % 2 == 0 #arbitrary pseudo randomness
        counter += 1
        sponsorship.accepted!
        sponsorship.resolved_at = DateTime.now
      end

      if !sponsorship.save
        puts sponsorship.errors.full_messages
      end
    end
  end

  puts "#{'*'*(`tput cols`.to_i)}\n#{counter} sponsorships accepted!\n"

end