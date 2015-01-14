require 'rails_helper'

describe 'As a business I want to request to sponsor a cause' do

  before(:each) do
    @b = create(:business)
    @c = create(:cause, :is_activated => true)
    expect(@c.is_published).to eq(true)
    expect(@c.is_activated).to eq(true)
  end

  it 'should allow them to request a sponsorship' do

    login(@b)
    click_link 'Causes'
    find(".grid-item a").click
    click_link 'Request Sponsorship'
    click_button 'Send Request'
    expect(page).to have_content('Your request has been sent')

    last = Sponsorship.last
    expect(last).to be
    expect(last.business).to eq(@b)
    expect(last.cause).to eq(@c)
    expect(last.pending?).to eq(true)

    expect(ActionMailer::Base.deliveries).to_not be_empty
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq(['test_community@taliflo.com'])
    expect(mail.body).to have_content('Dear Taliflo Community')

  end

end