require 'rails_helper'

describe 'As a business I want to enter my stripe banking information' do

  include Support::Auth

  before(:each) do
    assert_front_end_up
    @b = create(:business)
    @b.update_attributes({:access_code => nil})
    expect(@b.is_published).to eq(false)
  end

  it 'should allow the business to connect to stripe' do

    login(@b)
    click_profile_menu
    click_link 'My Account'
    click_link 'Banking Information'
    find('#stripe-connect').click
    expect(page).to have_content('Development Mode')
    click_link 'Skip this account form'
    expect(page).to have_content('Your account has been connected to Stripe', :wait => 4)
    click_link 'Account Details'
    expect(page).to have_content('Account Status: Confirmed')

  end

end