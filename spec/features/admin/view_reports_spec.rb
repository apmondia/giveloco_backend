require 'rails_helper'

describe 'As an admin I want to login' do

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)

    @business = create(:business, :sponsorship_rate => 20)
    @sponsorships = create_list(:sponsorship, 3, :business => @business, :status => :accepted)
    @sponsorships.each do |s|
      create_list(:certificate, 4, :sponsorship => s, :amount => 50)
    end

    @business2 = create(:business, :sponsorship_rate => 50)
    @sponsorships2 = create_list(:sponsorship, 2, :business => @business2, :status => :accepted)
    @sponsorships2.each do |s|
      create_list(:certificate, 4, :sponsorship => s, :amount => 50)
    end
  end

  it 'should allow the admin to login' do

    login(@admin)
    expect(page).to have_content(@admin.first_name)
    expect(page).to have_content( "$#{AdminReport.first.sales_total.to_i}" )
    expect(page).to have_content( "$#{AdminReport.first.donation_total.to_i}" )

  end

end