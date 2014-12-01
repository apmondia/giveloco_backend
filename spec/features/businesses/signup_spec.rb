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

    find('form button[type="submit"]').click
    expect(page).to have_css('.alert-success')
    expect(page).to have_content('Apple Inc.')
  end

end