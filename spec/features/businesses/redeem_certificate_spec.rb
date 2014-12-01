require 'rails_helper'

describe 'As a business I want to redeem a certificate' do

  before(:each) do
    @b = create(:business)
    @c = create(:certificate, :sponsorship => create(:sponsorship, :business => @b))
  end

  it 'main success scenario' do
    login(@b)
    find('#redeem-certificate-button').click
    expect(page).to have_content('Certificate Code')
    fill_in :redemptionCode, :with => @c.redemption_code
    click_link_or_button 'Redeem'
    expect(page).to_not have_content('Certificate Code')
    expect(page).to have_content('You have successfully redeemed the gift certificate')
  end

end