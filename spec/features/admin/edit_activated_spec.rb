require 'rails_helper'

describe 'As the admin I want to activate and deactivate businesses' do

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)
  end

  it 'should allow the admin to activate businesses' do
    @b = create(:business)

    login(@admin)
    click_profile_menu
    click_link 'Dashboard'
    expect(page).to have_content(@b.company_name)
    expect(page).to have_content('Activated')
    find(".user-actions a.dropdown-toggle").click
    click_link 'Deactivate'
    expect(page).to have_content('Not Activated')

    expect(User.find(@b.id).is_activated).to eq(false)
  end

  it 'should allow the admin to activate businesses' do
    @b2 = create(:business)
    @b2.is_activated = false
    @b2.save!
    expect(@b2.is_activated).to eq(false)

    login(@admin)
    click_profile_menu
    click_link 'Dashboard'
    expect(page).to have_content(@b2.company_name)
    expect(page).to have_content('Not Activated')
    find(".user-actions a.dropdown-toggle").click
    click_link 'Activate'
    expect(page).not_to have_content('Not Activated')
    expect(page).to have_content('Activated')

    expect(User.find(@b2.id).is_activated).to eq(true)
  end

end