require 'rails_helper'

describe 'As a user I want to purchase a gift certificate' do

  before(:each) do
    @b = create(:business, :sponsorship_rate => 14)
    @s1 = create(:sponsorship, :business => @b, :status => :accepted)
    expect(@b.is_published).to be_truthy
    expect(@b.is_activated).to be_truthy
  end

  it 'should allow the user to purchase a gift certificate' do

    email = 'fake@fake.com'

    visit_root

    expect(page).to have_content(@b.company_name)
    click_link @b.company_name
    click_link 'Enter Gift Card'
    fill_in :serial_number, :with => '1234'
    fill_in :amount, :with => '$50'
    click_link 'Choose Charity'
    expect(page).to have_content(@s1.cause.company_name)
    find("label[data-sponsorship-id='#{@s1.id}']").click
    expect(page).to have_content(Certificate.format_donated_amount(50, @b.sponsorship_rate) )

    c = Certificate.last
    expect(c).to be
    expect(c.sponsorship).to eq(@s1)
    expect(c.purchaser.email).to_not eq(email)
    expect(c.donation_percentage).to eq(@b.sponsorship_rate)
    expect(c.serial_number).to eq('1234')

    fill_in :email, :with => email
    click_link_or_button 'Subscribe'
    expect(page).to have_content('Thank you for giving local!')

    c2 = Certificate.last

    expect(c2).to eq(c)
    expect(c2.purchaser.email).to eq(email)

  end

end