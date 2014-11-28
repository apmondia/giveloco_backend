class V1::Sponsorships::SponsorshipsController < V1::Base

  resource :sponsorships do

    desc 'List all sponsorships'
    get do
      @sponsorships = Sponsorship.all
      if is_authenticated
        present @sponsorships, :with => V1::Sponsorships::Entity
      else
        present @sponsorships, :with => V1::Sponsorships::Snapshot
      end
    end

    desc 'Get a single sponsorship'
    get '/:id' do
      @sponsorship = Sponsorship.find(params[:id])      
      if is_authenticated
        present @sponsorship, :with => V1::Sponsorships::Entity
      else
        present @sponsorship, :with => V1::Sponsorships::Snapshot
      end
    end

    desc 'Create a new sponsorship'
    params do
      requires :business_id, :type => Integer, :desc => 'Business'
      requires :cause_id, :type => Integer, :desc => 'Cause'
      requires :donation_percentage, :type => BigDecimal, :desc => "Investment Rate"
    end
    post do
      authenticate!
      create_sponsorship_params = safe_params(params).permit(:business_id, :cause_id, :donation_percentage)
      sponsorship = Sponsorship.new(create_sponsorship_params)
      can_or_die :read, sponsorship
      sponsorship.save!
      sponsorship
    end

    namespace '/:id' do

      desc 'Destroy a sponsorship'
      params do
        requires :id
      end
      delete do
        authenticate!
        destroy_sponsorship_params = safe_params(params).permit(:id)
        sponsorship = Sponsorship.find(destroy_sponsorship_params[:id])
        can_or_die :destroy, sponsorship
        sponsorship.destroy!
        sponsorship
      end

      resource '/resolve' do
        desc 'Accept a sponsorship'
        params do
          requires :status, :type => Integer, :desc => '1 == accepted or 2 == cancelled'
        end
        put do
          authenticate!
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