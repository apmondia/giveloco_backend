require 'rails_helper'

describe 'As a business I want to enter my stripe banking information' do

  include Support::Auth

  before(:each) do
    assert_front_end_up
    @b = create(:business)
  end

  it 'should allow the business to connect to stripe' do

    login(@b)
    expect(page).to have_content(@b.company_name)
    click_profile_menu
    click_link 'My Account'
    click_link 'Banking Information'
    find('#stripe-connect').click
    expect(page).to have_content('Development Mode')
    click_link 'Skip this account form'
    expect(page).to have_content('Connecting your Stripe account...')
    expect(page).to have_content('Your Stripe account has been connected')
  end

end