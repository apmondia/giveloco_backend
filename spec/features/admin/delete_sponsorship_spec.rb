require 'rails_helper'

describe 'As the admin I want to delete sponsorships' do

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)
    @s = create(:sponsorship)
  end

  it 'should allow the admin to delete' do

    login(@admin)
    open_sponsorships
    expect(page).to have_content(@s.id)
    find('tr.sponsorship .user-actions a.dropdown-toggle').click
    click_link 'Delete'
    expect(page).to have_content("Business: #{@s.business.company_name}")
    click_button 'Delete'
    expect(page).to have_content("Deleted")
    expect(page).to_not have_content(@s.cause.company_name)

    within ".navbar-header" do
      click_link 'Businesses'
    end

    expect(page).to_not have_content(@s.business.company_name)

  end

end