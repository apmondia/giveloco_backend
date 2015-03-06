require 'rails_helper'

describe 'As the admin I want to update sponsorship status' do

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)
    @s = create(:sponsorship, :status => :pending)
  end

  it 'should allow the admin to accept' do
    login(@admin)
    within 'nav' do
      click_link 'Businesses'
    end
    expect(page).not_to have_content(@s.business.company_name)

    open_sponsorships
    expect(find('tr.sponsorship')).to have_content('pending')
    find('tr.sponsorship .user-actions a.dropdown-toggle').click
    click_link 'Accept'
    expect(find('tr.sponsorship')).to have_content('accepted')

    within 'nav' do
      click_link 'Businesses'
    end

    expect(page).to have_content(@s.business.company_name)

  end

  it 'should allow the admin to cancel' do
    login(@admin)
    open_sponsorships
    expect(find('tr.sponsorship')).to have_content('pending')
    open_sponsorship_row_tool
    click_link 'Cancel'
    expect(find('tr.sponsorship')).to have_content('cancelled')
  end

  it 'should allow the admin to move to pending' do
    login(@admin)
    open_sponsorships
    expect(find('tr.sponsorship')).to have_content('pending')
    open_sponsorship_row_tool
    click_link 'Cancel'
    expect(find('tr.sponsorship')).to have_content('cancelled')

    open_sponsorship_row_tool
    click_link 'Pending'
    expect(find('tr.sponsorship')).to have_content('pending')

  end

end