require 'rails_helper'

describe 'As a cause I want to edit my profile' do

  before(:each) do
    @c = create(:cause)
  end

  def goto_edit_profile
    login(@c)
    click_profile_menu
    click_link 'My Account'
    expect(page).to have_content(@c.street_address)
    click_link 'Edit Profile'
  end

  it 'should work' do

    goto_edit_profile
    expect(page).to have_content('Edit Cause Location')
    fill_in :userStreetAddress, :with => '1234 Evergreen Terrace'
    fill_in :userCity, :with => 'Moncton'
    fill_in :userDescription, :with => 'This is a large company'
    click_link 'Causes'
    expect(page).to have_content('You have unsaved changes')
    click_link_or_button 'Cancel'
    click_link_or_button 'Save Changes'
    expect(page).to have_content('Your account information was successfully updated')
    expect(page).to have_content('Edit Profile')
    expect(page).to have_content('1234 Evergreen Terrace')

  end

  it 'should allow the user to cancel their edits' do

    goto_edit_profile
    fill_in :userCity, :with => 'asdf'
    click_link_or_button 'Cancel'
    expect(page).not_to have_content('asdf')
    expect(page).not_to have_content('Editing')

  end

end