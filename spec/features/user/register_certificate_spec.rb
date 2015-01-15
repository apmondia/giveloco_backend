require 'rails_helper'

describe 'As a user I want to purchase a gift certificate' do

  before(:each) do
    @b = create(:business)
    @s1 = create(:sponsorship, :business => @b, :status => :accepted)
  end

  it 'should allow the user to purchase a gift certificate' do

    email = 'fake@fake.com'

    visit '/'
    click_link 'Explore'
    click_link @b.company_name
    click_link 'Enter Gift Card'
    fill_in :serial_number, :with => '1234'
    fill_in :amount, :with => '$50'
    click_link 'Choose Charity'
    expect(page).to have_content(@s1.cause.company_name)
    find("label[data-sponsorship-id='#{@s1.id}']").click
    click_link 'Donate'
    expect(page).to have_content('Customer Details')
    fill_in :email, :with => email
    find('label[for="agree_to_tc"]').click
    click_link_or_button 'Confirm'
    expect(page).to have_content('Thank you for giving it forward!')

    c = Certificate.last
    expect(c).to be
    expect(c.sponsorship).to eq(@s1)
    expect(c.purchaser.email).to eq(email)
    expect(c.donation_percentage).to eq(@b.sponsorship_rate)
    expect(c.serial_number).to eq('1234')

  end

end