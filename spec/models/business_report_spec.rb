require 'rails_helper'

describe BusinessReport do

  before(:each) do
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

  it 'should correctly calculate the total number of certificates for a business' do
    report = BusinessReport.find(@business.id)
    expect(report.certificates_count).to eq(12)
    expect(report.sales_total).to eq( 12 * 50 )
    expect(report.donation_total).to eq( 12 * 50 * 0.2 )
  end

  it 'should correctly link with businesses' do

    expect(@business.report).to eq( BusinessReport.find(@business.id) )
    expect(BusinessReport.find(@business.id).business).to eq(@business)

  end

  it 'should be reflected in the admin report' do

    ar = AdminReport.first

    expect(ar.business_count).to eq(2)
    expect(ar.certificates_count).to eq(20)
    expect(ar.sales_total).to eq( 12 * 50 + 8 * 50)
    expect(ar.donation_total).to eq( (12*50*0.2) + (8*50*0.5) )

  end

end