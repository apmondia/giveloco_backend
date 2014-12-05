require 'rails_helper'

describe 'As a business I want to sign up' do

  include Support::FrontEnd

  before(:each) do
    assert_front_end_up
  end

  it 'should allow the business to sign up ' do

    visit '/'
    find("#footer-sign-up").click

    fill_in :company, :with => 'Apple Inc.'
    fill_in :first_name, :with => 'Bob'
    fill_in :last_name, :with => 'Sapphire'
    fill_in :email, :with => 'test@afseijf.com'
    fill_in :password, :with => 'password'
    find('label[for="business-registration-terms"]').click

    find_button('Sign Up').click
    expect(page).to have_content("We've sent you a confirmation email.  Activate your account with the embedded link.", :wait => 5)
    expect(page).to have_content('Apple Inc.')

    confirmation_link = expect_confirmation_email('test@afseijf.com')

    visit confirmation_link
    expect(page).to have_content('Your account was successfully confirmed.')
    expect(page).to have_content('Apple Inc.')

  end

end