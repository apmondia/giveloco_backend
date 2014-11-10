require 'rails_helper'

describe V1::Sponsorships::SponsorshipsController do

  include Support::Auth

  describe 'POST /v1/sponsorships' do

    let(:post_params) {
      {
          :business_id => @business.id,
          :cause_id => @cause.id
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

    describe 'Exception scenarios' do

      it 'Should prevent the business from having more than 3 sponsorships' do

        create_list(:sponsorship, User::MAX_SPONSORED_CAUSES, :business => @business)
        post '/v1/sponsorships', post_params, auth_session(@admin)
        expect( response.status ).to eq(422)
        expect( User.find(@business.id).causes.size ).to eq(User::MAX_SPONSORED_CAUSES)

      end

    end

  end

end