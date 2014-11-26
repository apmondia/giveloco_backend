require 'rails_helper'

describe 'As a business I want to enter my stripe banking information' do

  include Support::Auth

  before(:each) do
    @b = create(:business)
  end

  it 'should allow the business to connect to stripe' do

    login(@b)
    expect(page).to have_content(@b.company_name)
    find('button.close').click
    find('.nav .dropdown-toggle').click
    click_link 'My Account'
    click_link 'Banking Information'
    find('#stripe-connect').click
    expect(page).to have_content('Development Mode')
    click_link 'Skip this account form'
    expect(page).to have_content('Connecting your Stripe account...')
    old_wait_time = set_wait_time_to(10)
    expect(page).to have_content('Your Stripe account has been connected')
    set_wait_time_to old_wait_time

  end

end