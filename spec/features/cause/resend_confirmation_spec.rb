require 'rails_helper'

describe 'As a cause I want resend my confirmation instructions' do

  before(:each) do
    @c = create(:cause)
  end

  def goto_my_account
    login(@c)
    click_link "Hi, #{@c.first_name}"
    click_link 'My Account'
  end

  it 'should work' do
    goto_my_account
    click_link 'Account Settings'
    click_link 'Resend Confirmation'
    expect(ActionMailer::Base.deliveries).to_not be_empty
    message = ActionMailer::Base.deliveries.last
    expect(message.to).to eq([@c.email])
    expect(message.subject).to eq('GiveLoco Account Confirmation')
  end

  # it 'should not display the resend for confirmed users' do
  #   @c.confirm!
  #   goto_my_account
  #   expect(page).to_not have_content('Resend Instructions')
  # end

end