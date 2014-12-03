require 'rails_helper'

describe 'As a user I want to purchase a gift certificate' do

  before(:each) do
    @b = create(:business)
    @b2 = create(:business, :access_code => nil)
    @s1 = create(:sponsorship, :business => @b)
    @s2 = create(:sponsorship, :business => @b)
  end

  it 'should allow the user to purchase a gift certificate' do

    stripe_connect(@b)

    visit '/'
    click_link 'View Gift Certificates'
    expect(page).to_not have_content(@b2.company_name)
    click_link @b.company_name
    click_link 'Buy a Gift Certificate'
    find('label[for="amount50"]').click
    fill_in :first_name, :with => 'Bob'
    fill_in :last_name, :with => 'Dole'
    fill_in :email, :with => 'bobdole@superfake.com'
    fill_in :creditCard, :with => '5555555555554444'
    fill_in :expiry, :with => '01 2015'
    fill_in :cvc, :with => 123
    click_link 'Choose a Cause'
    expect(page).to have_content(@s1.cause.company_name)
    find("label[data-sponsorship-id='#{@s1.id}']").click
    click_link 'Checkout'
    expect(page).to have_content('Customer Details')
    find('label[for="agree_to_tc"]').click
    click_link_or_button 'Confirm Purchase'
    expect(page).to have_content('Your transaction was completed successfully!')

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be
    expect(mail.to).to eq(['bobdole@superfake.com'])

  end

end