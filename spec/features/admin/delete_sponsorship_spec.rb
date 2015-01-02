require 'rails_helper'

describe 'As the admin I want to delete sponsorships' do

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)
    @s = create(:sponsorship)
  end

  it 'should allow the admin to delete' do

    login(@admin)
    click_profile_menu
    click_link 'Dashboard'
    expect(page).to have_content('Sponsorships')
    click_link 'Sponsorships'
    expect(page).to have_content(@s.id)
    expect(page).to have_content(@s.donation_percentage)
    find('tr.sponsorship .user-actions a.dropdown-toggle').click
    click_link 'Delete'
    expect(page).to have_content("Business: #{@s.business.company_name}")
    click_button 'Delete'
    expect(page).to have_content("Deleted")
    expect(page).to_not have_content(@s.cause.company_name)

  end

end