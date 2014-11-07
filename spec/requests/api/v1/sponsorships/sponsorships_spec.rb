require 'rails_helper'

describe V1::Sponsorships::SponsorshipsController do

  describe 'POST /v1/sponsorships' do

    include Support::Auth

    let(:post_params) {
      {
          :from_user_id => @business.id,
          :to_user_id => @cause.id
      }
    }

    before(:each) do
      @admin = create(:admin)
      @business = create(:business)
      @cause = create(:cause)
    end

    def post_with_user(user)
      post '/v1/sponsorships', post_params, auth_session(user)
    end

    it 'should allow a business to request a sponsorship' do
      post_with_user(@business)
      expect( response.status ).to eq(201)
    end

    it 'should allow an admin to request a sponsorship' do
      post_with_user(@admin)
      expect( response.status ).to eq(201)
    end

    it 'should prevent anonymous sponsorship request' do
       post '/v1/sponsorships', post_params
      expect( response.status ).to eq(401)
    end

    it 'should prevent anybody from sponsoring' do
      post '/v1/sponsorships', post_params, auth_session( create(:business) )
      expect( response.status ).to eq(403)
    end

  end

end