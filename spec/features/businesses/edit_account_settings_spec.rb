require 'rails_helper'

describe 'Edit Account Settings' do

  before(:each) do
    @b = create(:business)
    login(@b)
  end

  it 'should require a password to change their sponsorship rate' do
    open_my_account
    click_link 'Account Settings'
    fill_in :sponsorship_rate, :with => 20
    click_link_or_button 'Update'
    expect(page).to have_content("You must provide your password.")
  end

  it 'should allow the user to change their sponsorship rate' do
    open_my_account
    click_link 'Account Settings'
    fill_in :sponsorship_rate, :with => 20
    fill_in :currentPassword, :with => 'password'
    click_link_or_button 'Update'
    expect(page).to have_content("Your account has been updated")

    expect( User.find(@b.id).sponsorship_rate ).to eq(20)
  end

  it 'should allow the user to change their password' do

    open_my_account
    click_link 'Account Settings'
    fill_in :currentPassword, :with => 'password'
    fill_in :newPassword, :with => 'testtest'
    fill_in :confirmPassword, :with => 'testtest'
    click_link_or_button 'Update'

    expect(page).to have_content("Your account has been updated")

    click_profile_menu
    click_link 'Log Out'

    fill_in :email, :with => @b.email
    fill_in :password, :with => 'testtest'
    click_button "Log In"

    expect(page).to_not have_content("Unable to log")

  end

end