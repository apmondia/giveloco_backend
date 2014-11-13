class V1::Sponsorships::SponsorshipsController < V1::Base

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

    namespace '/:id' do

      resource '/resolve' do
        desc 'Accept a sponsorship'
        params do
          requires :status, :type => Integer, :desc => '1 == accepted or 2 == cancelled'
        end
        put do
          sponsorship = Sponsorship.find(params[:id])
          can_or_die :resolve, sponsorship
          if sponsorship.status.to_sym == :pending
            sponsorship.update_attributes(:status => params[:status])
            sponsorship.resolved_at = DateTime.now
            sponsorship.save
          else
            status 422
          end
          sponsorship
        end
      end

    end




  end
end