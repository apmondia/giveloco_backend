require 'rails_helper'
require 'stripe_charge'

describe V1::Users::UsersController do

  describe 'GET /v1/users/role/cause' do

    it 'should not return anything' do
      get '/v1/users/role/cause'
      expect( JSON.parse(response.body).size ).to eq(0)
    end

    it 'should return all the causes' do

      @businesses = create_list(:business, 3)
      @causes = create_list(:cause, 4)

      get '/v1/users/role/cause'
      expect( response.status ).to eq(200)
      resp = JSON.parse(response.body)
      expect( resp.size ).to eq(4)

      expect( resp[0]['id'] ).to eq(@causes[0].id)
      expect( resp[1]['id'] ).to eq(@causes[1].id)
      expect( resp[2]['id'] ).to eq(@causes[2].id)
      expect( resp[3]['id'] ).to eq(@causes[3].id)

    end

  end

  describe 'PUT /v1/users/:id' do

    before(:each) do
      @b = create(:business, :is_activated => false)
      @admin = create(:admin)
    end

    it 'should allow users to update their own profile' do
      put "/v1/users/#{@b.id}", {
          :first_name => 'foo'
      }, auth_session(@b)
      expect( User.find(@b.id).first_name ).to eq('foo')
    end

    it 'should not allow users to update their active/inactive state' do
      put "/v1/users/#{@b.id}", {
          :is_activated => true
      }, auth_session(@b)
      expect( User.find(@b.id).is_activated ).to eq(false)
    end

    it 'should allow admins to update profiles and activate / deactive them' do
      put "/v1/users/#{@b.id}", {
          :is_activated => true
      }, auth_session(@admin)
      expect( User.find(@b.id).is_activated ).to eq(true)
    end

    describe 'exception scenarios' do

      it 'should not allow anybody to edit anybodys profile' do

        put "/v1/users/#{@b.id}", {
            :first_name => 'TomatoWasher'
        }, auth_session( create(:business) )

        expect( response.status ).to eq(403)
        expect( User.find(@b.id).first_name ).to_not eq('TomatoWasher')

      end

    end

  end

  describe 'GET /v1/users/:id/certificates' do

    before(:each) do
      @u = create(:user)
      @c = create(:certificate, :purchaser => @u)
    end

    def expect_certificate
      json = JSON.parse(response.body)
      expect( json.length ).to eq(1)
      expect( json[0]['id'] ).to eq(@c.id)
    end

    it 'should allow a user to check their certificates' do
      get "/v1/users/#{@u.id}/certificates", {}, auth_session(@u)
      expect( response.status ).to eq(200)
      expect_certificate
    end

    it 'should not allow anyone to check a users certificates' do
      get "/v1/users/#{@u.id}/certificates", {}
      expect( response.status ).to eq(401)
    end

    it 'should not allow another user to check a users certificates' do
      get "/v1/users/#{@u.id}/certificates", {}, auth_session(create(:business))
      expect( response.status ).to eq(403)
    end


  end

  describe 'GET /v1/users/:id/sponsors' do

    before(:each) do
      @c = create(:cause)
      @businesses = create_list(:business, 3)
      @businesses.each do |b|
        create(:sponsorship, :cause => @c, :business => b)
      end
    end

    it 'should allow anyone to view a causes sponsors' do

      get "/v1/users/#{@c.id}/sponsors"

      expect( response.status ).to eq(200)
      json = JSON.parse(response.body)
      expect( json.length ).to eq(3)

    end

  end

  describe 'GET /v1/users/:id/transactions' do

    before(:each) do
      @b = create(:business)
      @c1 = create(:certificate, :sponsorship => create(:sponsorship, :business => @b))
    end

    it 'should allow a business or admin to access the businesses certificates' do

      get "/v1/users/#{@b.id}/transactions", {}, auth_session(@b)
      expect(response.status).to eq(200)
      expect( JSON.parse(response.body).length ).to eq(1)

    end

  end

  describe 'GET /v1/users/:id/donations' do

    before(:each) do
      @c = create(:cause)
      @c1 = create(:certificate, :sponsorship => create(:sponsorship, :cause => @c))
    end

    it 'should allow a cause to look up its certificates' do

      get "/v1/users/#{@c.id}/donations", {}, auth_session(@c)
      expect( response.status ).to eq(200)
      expect( JSON.parse(response.body).length ).to eq(1)

    end

  end

  describe 'POST /users/certificates' do

    before(:each) do
      @s = create(:sponsorship)
    end

    it 'should allow an anonymous user to purchase a certificate' do

      expect(StripeCharge).to receive(:call).with({
          :amount => 2000,
          :card => 'stripeToken',
          :application_fee => (@s.business.sponsorship_rate * 20.0).to_i,
          :description => "Gift Certificate for #{@s.business.company_name}",
          :access_token => @s.business.access_code
                                                  })

      post '/v1/users/certificates', {
          :newUser => {
              :first_name => 'Bob',
              :last_name => 'Odenkirk',
              :email => 'testman@fake.com',
              :mailing_list_opt_in => true,
              :agree_to_tc => true,
              :certificates_attributes => [{
                  :sponsorship_id => @s.id,
                  :amount => "20",
                  :stripeToken => 'stripeToken'
              }]
          }
      }

      expect(response.status).to eq(201)
      last_user = User.last
      expect(last_user.certificates).to_not be_empty
      last_mail = ActionMailer::Base.deliveries.last
      # users don't have account anymore.
      expect(last_user.email).to eq('testman@fake.com')
      expect(last_user.mailing_list_opt_in).to eq(true)
      expect(last_mail.to).to eq(['testman@fake.com'])

    end



  end

  describe '/v1/users/:id/sponsorships/certificates' do

    before(:each) do
      @b = create(:business)
      @c1 = create(:certificate, :sponsorship => create(:sponsorship, :business => @b))
      @c2 = create(:certificate, :sponsorship => create(:sponsorship, :business => @b))
    end

    it 'should show the business all of its certificates' do

      get "/v1/users/#{@b.id}/sponsorships/certificates"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect( json.length ).to eq(2)

    end

  end

  describe 'PUT /v1/users/:id' do

    before(:each) do
      @b = create(:business)
    end

    it 'should allow the business to change passwords' do

      put "/v1/users/#{@b.id}", {
          :id => @b.id,
          :user => {
              :current_password => 'password',
              :password => 'testtest',
              :password_confirmation => 'testtest'
          }
      }, auth_session(@b)

    end

  end

  describe '/v1/users/:id/sponsors/certificates' do

    before(:each) do
      @cause = create(:cause)
      @c1 = create(:certificate, :sponsorship => create(:sponsorship, :cause => @cause))
      @c2 = create(:certificate, :sponsorship => create(:sponsorship, :cause => @cause))
    end

    it 'should show a cause all of the certificates purchased for it' do

      get "/v1/users/#{@cause.id}/sponsors/certificates"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect( json.length ).to eq(2)

    end

  end

end