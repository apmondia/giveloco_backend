require 'rails_helper'

describe 'As the admin I want to view all sponsorships' do

  include Support::Auth

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)
    @s = create(:sponsorship)
  end

  it 'should display all sponsorships' do

    login(@admin)
    click_profile_menu
    click_link 'Dashboard'
    expect(page).to have_content('Sponsorships')
    click_link 'Sponsorships'
    expect(page).to have_content(@s.id)
    expect(page).to have_content(@s.donation_percentage)

  end

end