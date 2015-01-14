require 'rails_helper'

describe 'As an admin I want to create a sponsorship' do

  before(:each) do
    @admin = create(:admin)
    @business = create(:business)
    @cause = create(:cause)
  end

  it 'should create a sponsorship' do

    login(@admin)
    expect(page).to have_content(@admin.first_name)
    open_sponsorships
    expect(page).to have_content('Total Sponsorships')
    find("#create-sponsorship-button").click
    fill_in :'select-business', :with => @business.company_name
    click_typeahead_business
    fill_in :'select-cause', :with => @cause.company_name
    click_typeahead_cause
    fill_in :'donation-percentage', :with => 24
    find('form button[type="submit"]').click
    expect(page).to have_content('A new Sponsorship was successfully created!')
    expect(page).to have_content(@cause.company_name)

  end

end