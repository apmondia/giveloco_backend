require 'rails_helper'

describe 'As the admin I want to view all sponsorships' do

  include Support::Auth

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)
    @s = create(:sponsorship, :status => :accepted)
    @s2 = create(:sponsorship, :status => :pending)
  end

  it 'should display all sponsorships' do

    login(@admin)
    open_sponsorships
    expect(page).to have_content(@s.id)
    expect(page).to have_content('accepted')
    expect(page).to have_content('pending')
    expect(page).to have_content(@s2.id)
    expect(page).to have_content(@s2.business.sponsorship_rate)

  end

end