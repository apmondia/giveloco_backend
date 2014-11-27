require 'rails_helper'

describe Certificate do

  before(:each) do
    @s = create(:sponsorship)
  end

  describe 'create' do

    it 'should charge the Stripe api when created' do

      expect(StripeCharge).to receive(:call).with({
          :amount => 20*100,
          :card => 'stripeToken',
          :application_fee => (100 + (@s.donation_percentage * 20)),
          :access_token => '1234'
                                                  })

      c = Certificate.create( {
                                  :amount => 20,
                                  :purchaser => create(:user),
                                  :sponsorship => @s,
                                  :stripeToken => 'stripeToken'} )

      expect(c.errors.full_messages).to eq([])

    end

  end

end
