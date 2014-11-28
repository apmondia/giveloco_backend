require 'rails_helper'

describe '/v1/certificates' do

  before(:each) do
    @c = create(:certificate)
  end

  describe '/redeem' do

    it 'should allow the business to redeem its certificate' do
      patch '/v1/certificates/redeem', { :redemption_code => @c.redemption_code }, auth_session( @c.sponsorship.business )
      expect(response.status).to eq(200)
    end

    it 'should not allow the owner to redeem a certificate' do
      patch '/v1/certificates/redeem', { :redemption_code => @c.redemption_code }, auth_session( @c.purchaser )
      expect(response.status).to eq(403)
    end

    it 'should not allow anyone to redeem a certificate' do
      patch '/v1/certificates/redeem', { :redemption_code => @c.redemption_code }, {}
      expect(response.status).to eq(401)
    end

  end



end