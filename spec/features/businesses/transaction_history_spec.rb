require 'rails_helper'

describe 'As a business I want a transaction history' do

  before(:each) do
    @b = create(:business)
    @s1 = create(:sponsorship, :business => @b, :status => :accepted)
    @c = create(:certificate, :sponsorship => @s1)
    @c2 = create(:certificate, :sponsorship => @s1)
  end

  def expect_certificate_content(c)
    expect(page).to have_content(c.sponsorship.cause.company_name)
    expect(page).to have_content(c.donation_percentage)
    expect(page).to have_content(c.serial_number)
  end

  def goto_certificates
    login(@b)
    click_profile_menu
    click_link 'Dashboard'
    click_link 'Certificates'
  end

  it 'should allow the business to view the transaction history' do

    goto_certificates
    expect(page).to have_content('Certificates')
    expect_certificate_content(@c)
    expect_certificate_content(@c2)

  end

end