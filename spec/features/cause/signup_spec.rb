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
    find('form button[type="submit"]').click
    old_wait_time = set_wait_time_to 10
    expect(page).to have_content('You have successfully registered')
    expect(page).to have_content('Freedom Org')
    set_wait_time_to old_wait_time

  end

end