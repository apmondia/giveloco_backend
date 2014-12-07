require 'rails_helper'

describe 'As a cause I want to sign up' do

  before(:each) do
    assert_front_end_up
  end

  it 'should allow a cause to sign up' do

    visit '/'
    find('#footer-sign-up').click
    click_link 'Cause'
    fill_in :company, :with => 'Freedom Org'
    fill_in :first_name, :with => 'Bill'
    fill_in :last_name, :with => 'Bob'
    fill_in :email, :with => 'bob_fake_email@fakefake.com'
    fill_in :password, :with => 'password'
    find('label[for="cause-registration-terms"]').click

    expect(page).to_not have_css('#cause-sign-up[disabled="disabled"]')
    find_button('Sign Up').click
    expect(page).to have_content("We've sent you a confirmation email.  Activate your account with the embedded link.", :wait => 5)
    expect(page).to have_content('Hi, Bill')

    confirmation_link = expect_confirmation_email('bob_fake_email@fakefake.com')

    visit confirmation_link
    expect(page).to have_content('Your account was successfully confirmed.')
    expect(page).to have_content('Hi, Bill')

  end

end