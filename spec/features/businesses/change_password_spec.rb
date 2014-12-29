require 'rails_helper'

describe 'Change Password' do

  before(:each) do
    @b = create(:business)
    login(@b)
  end

  it 'should work' do

    open_my_account
    click_link 'Change Password'
    fill_in :currentPassword, :with => 'password'
    fill_in :newPassword, :with => 'testtest'
    fill_in :confirmPassword, :with => 'testtest'
    click_link_or_button 'Update Password'

    expect(page).to have_content("Your password")

    click_profile_menu
    click_link 'Log Out'

    fill_in :email, :with => @b.email
    fill_in :password, :with => 'testtest'
    click_button "Log In"


    expect(page).to_not have_content("Unable to log")

  end

end