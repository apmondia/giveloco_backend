require 'rails_helper'

describe V1::Sponsorships::SponsorshipsController do

  include Support::Auth

  before(:each) do
    @admin = create(:admin)
    @business = create(:business)
    @cause = create(:cause)
  end

  describe 'POST /v1/sponsorships' do

    let(:post_params) {
      {
          :business_id => @business.id,
          :cause_id => @cause.id
      }
    }

    def post_with_user(user)
      post '/v1/sponsorships', post_params, auth_session(user)
    end

    it 'should allow a business to request a sponsorship' do
      create_list(:sponsorship, Sponsorship::MAX_FAILED_REQUESTS - 1, :business => @business)
      post_with_user(@business)
      expect( response.status ).to eq(201)
    end

    it 'should not allow a business to request a sponsorship while one is pending' do
      s = create(:sponsorship, :business => @business, :cause => @cause)
      post_with_user(@business)
      expect( response.status ).to eq(422)
    end

    it 'should allow a business to re-request a sponsorship if the previous ones were cancelled' do
      s = create(:sponsorship, :business => @business, :cause => @cause, :status => Sponsorship.statuses[:cancelled])
      post_with_user(@business)
      expect( response.status ).to eq(201)
    end

    it "should prevent a business from requesting sponsorship when it has been cancelled #{Sponsorship::MAX_FAILED_REQUESTS} times" do
      s = create_list(:sponsorship, Sponsorship::MAX_FAILED_REQUESTS, :business => @business, :cause => @cause, :status => Sponsorship.statuses[:cancelled])
      post_with_user(@business)
      expect( response.status ).to eq(422)
      expect( @business.sponsorships.count ).to eq(Sponsorship::MAX_FAILED_REQUESTS)
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

        create_list(:sponsorship, Sponsorship::MAX_SPONSORED_CAUSES, :business => @business)
        post '/v1/sponsorships', post_params, auth_session(@admin)
        expect( response.status ).to eq(422)
        expect( User.find(@business.id).causes.size ).to eq(Sponsorship::MAX_SPONSORED_CAUSES)

      end

    end

    describe 'PUT /v1/sponsorships/:id/resolve' do

      before(:each) do
        @s = create(:sponsorship, :business => @business, :cause => @cause)
      end

      it 'should allow causes to resolve sponsorships' do

        put "/v1/sponsorships/#{@s.id}/resolve", { :status => Sponsorship.statuses[:accepted] }, auth_session(@cause)
        expect(Sponsorship.find(@s.id).accepted?).to eq(true)

      end

    end

  end

end