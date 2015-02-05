require 'rails_helper'
require 'stripe_charge'

describe V1::Users::UsersController do


  describe 'GET /v1/users' do

    before(:each) do
      @b1 = create(:business)
      @b1.campaign_list.add 'foo'
      @b1.tag_list.add 'none'
      @b1.save!
      @s1 = create(:sponsorship, :business => @b1, :status => :accepted)
      @b2 = create(:business)
      @b2.tag_list.add 'bar'
      @b2.campaign_list.add 'foo'
      @b2.save!
      @b3 = create(:business)
      @s3 = create(:sponsorship, :business => @b3, :status => :accepted)
      @b3.campaign_list.add 'bar'
      @b3.campaign_list.add 'none'
      @b3.save!
    end

    it 'should allow the user to search by regular tags' do

      get "/v1/users", { :t => 'foo' }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json[0]['id']).to eq(@b1.id)


      get "/v1/users", { :t => 'none' }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      ids = json.map { |val| val['id'] }
      expect(ids).to include(@b1.id)
      expect(ids).to include(@b3.id)

    end

    it 'should allow the user to search by campaign tags' do

    end

  end

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
                  :serial_number => '1234'
              }]
          }
      }

      expect(response.status).to eq(201)
      last_user = User.last
      expect(last_user.certificates).to_not be_empty
      expect(last_user.certificates.size).to eq(1)
      last_mail = ActionMailer::Base.deliveries.last
      # users don't have account anymore.
      expect(last_user.email).to eq('testman@fake.com')
      expect(last_user.mailing_list_opt_in).to eq(true)

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
                                               :serial_number => '1121234'
                                           }]
          }
      }

      expect(response.status).to eq(201)
      last_user = User.last
      expect(last_user.certificates).to_not be_empty
      expect(last_user.certificates.size).to eq(2)

    end



  end

  describe '/v1/users/:id/sponsorships/certificates' do

    before(:each) do
      @b = create(:business)
      @c1 = create(:certificate, :sponsorship => create(:sponsorship, :business => @b))
      @c2 = create(:certificate, :sponsorship => create(:sponsorship, :business => @b))
      @url = "/v1/users/#{@b.id}/sponsorships/certificates"
    end

    it 'should not allow the public to view a businesses certificates' do
      get @url
      expect(response.status).to eq(401)
    end


    describe '/csv' do
      it 'should allow business to download their certificates as CSV files' do
        get "#{@url}/csv", {}, auth_session(@b)
        expect(response.status).to eq(200)
        expect(response.content_type).to eq('text/csv')
        expect(response.body).to eq( @b.purchased_certificates.to_comma )
        expect(response.header['Content-Disposition']).to eq('attachment; filename=certificates.csv')
      end
    end


    it 'should not allow another user to view a businesses certificates' do
      get @url, {}, auth_session(@c1.sponsorship.cause)
      expect(response.status).to eq(403)
    end

    it 'should show the business all of its certificates' do
      get @url, {}, auth_session(@b)
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect( json.length ).to eq(2)
    end

  end

  describe 'PUT /v1/users/:id' do

    before(:each) do
      @b = create(:business)
      @b2 = create(:business)
      @admin = create(:admin)
    end

    it 'should allow the business to update its profile' do
      put "/v1/users/#{@b.id}", {
        :company_name => 'asdf'
      }, auth_session(@b)
      expect(User.find(@b.id).company_name).to eq('asdf')
    end

    it 'should remove any tags that are campaign tags' do
      put "/v1/users/#{@b.id}", {
        :tags_list => [
            'foo'
        ]
      }
    end

    it 'should not allow a business to update its campaign tags' do
      put "/v1/users/#{@b.id}", {
        :campaign_list => [
            'hello'
        ]
      }, auth_session(@b)
      expect(response.status).to eq(200)
      expect(User.find(@b.id).campaign_list).not_to include('hello')
    end

    it 'should allow the admin to update the campaign tags' do
      put "/v1/users/#{@b.id}", {
        :campaign_list => [
            'hello'
        ]
      }, auth_session(@admin)
      expect(response.status).to eq(200)
      expect(User.find(@b.id).campaign_list).to include('hello')
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