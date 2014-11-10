class V1::Sponsorships::SponsorshipsController < V1::Base
  include V1::Defaults

  resource :sponsorships do

    desc 'Create a new sponsorship'
    params do
      requires :business_id, :type => Integer, :desc => 'Business'
      requires :cause_id, :type => Integer, :desc => 'Cause'
    end
    post do
      authenticate!
      create_sponsorship_params = safe_params(params).permit(:business_id, :cause_id)
      sponsorship = Sponsorship.new(create_sponsorship_params)
      can_or_die :create, sponsorship
      sponsorship.save!
      sponsorship
    end

  end
end