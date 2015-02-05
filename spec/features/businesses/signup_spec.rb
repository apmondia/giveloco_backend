require 'rails_helper'

describe 'As a business I want to sign up' do

  include Support::FrontEnd

  before(:each) do
    assert_front_end_up
    @b = create(:business)
  end

  def fill_out_signup
    fill_in :company, :with => "Apple's Inc."
    fill_in :first_name, :with => 'Bob'
    fill_in :last_name, :with => 'Sapphire'
    fill_in :email, :with => 'test@afseijf.com'
    fill_in :password, :with => 'password'
    fill_in :sponsorship_rate, :with => '32%'
    find('label[for="business-registration-terms"]').click
  end

  it 'should allow the business to sign up ' do

    visit_root
    find("#footer-sign-up").click
    fill_out_signup
    find_button('Sign Up').click
    expect(page).to have_content("We've sent you a confirmation email.  Activate your account with the embedded link.", :wait => 5)
    expect(page).to have_content("Apple's Inc.")

    confirmation_link = expect_confirmation_email('test@afseijf.com')

    visit confirmation_link
    expect(page).to have_content('Your account was successfully confirmed.')
    expect(page).to have_content("Hi, Bob")

    u = User.last
    expect(u.email).to eq('test@afseijf.com')
    expect(u.sponsorship_rate).to eq(32)

  end

  it 'should display a message if the name or email address already exists' do


    visit_root
    find("#footer-sign-up").click
    fill_out_signup
    fill_in :email, :with => @b.email
    find_button('Sign Up').click
    expect(page).to have_content("Email has already been taken")

    fill_in :email, :with => 'asldkfjad@asldfkj.com'
    fill_in :company, :with => @b.company_name
    find_button('Sign Up').click
    expect(page).to have_content("Company name has already been taken")

  end

end