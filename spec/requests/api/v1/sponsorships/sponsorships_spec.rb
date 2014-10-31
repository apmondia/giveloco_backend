require 'rails_helper'

describe V1::Sponsorships::SponsorshipsController do

  describe 'POST /v1/sponsorships' do

    before(:each) do
      @business = create(:business)
      @cause = create(:cause)
    end

    it 'should prevent unauthorized sponsorship requests' do

      sign_in create(:user)

      post '/v1/sponsorships', {
          :from_user_id => @business.id,
          :to_user_id => @cause.id
      }

      expect( response.status ).to eq(401)

    end

  end

end