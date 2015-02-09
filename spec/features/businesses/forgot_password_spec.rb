require 'rails_helper'

describe 'As a business I want to change my password' do

  before(:each) do
    assert_front_end_up
    @business = create(:business)
  end

  it 'should work' do

    visit_root
    find('footer a.login').click
    click_link "I forgot my password"
    expect(page).to have_content("Reset your Password")
    fill_in :email, :with => @business.email
    click_link_or_button 'Send me a new password'
    expect(page).to have_content("We've sent you a password")

    url = expect_password_reset_email(@business)

    visit url
    expect(page).to have_content("Enter your new Password")

    fill_in :password, :with => 'password2'
    fill_in :password_confirmation, :with => 'password2'

    click_link_or_button 'Confirm New Password'
    expect(page).to have_content("Your password has been reset")

    fill_in :email, :with => @business.email
    fill_in :password, :with => 'password2'

    find('form button[type="submit"]').click

    expect(page).to have_content(@business.company_name)
    expect(page).to have_content("You have success")

  end

end