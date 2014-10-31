class V1::Sponsorships::SponsorshipsController < V1::Base
  include V1::Defaults

  resource :sponsorships do

    desc 'Create a new sponsorship'
    params do
      requires :from_user_id, :type => Integer, :desc => 'Business'
      requires :to_user_id, :type => Integer, :desc => 'Cause'
    end
    post do
      authenticate!
      can? :create, Sponsorship, params
      Sponsorship.create!(params)
    end

  end
end