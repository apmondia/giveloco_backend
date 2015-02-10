require 'rails_helper'

describe '/v1/business_reports' do

  before(:each) do

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

  it 'GET returns AdminReport' do
    get '/v1/business_reports', {}, auth_session(@admin)
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json['business_count']).to eq( AdminReport.first.business_count )
    expect(json['certificates_count']).to eq( AdminReport.first.certificates_count )
    expect(json['sales_total']).to eq( AdminReport.first.sales_total )
    expect(json['donation_total']).to eq( AdminReport.first.donation_total )
  end

  it 'disallow GET for anonymous users' do
    get '/v1/business_reports', {}, {}
    expect(response.status).to eq(401)
  end

  it 'disallows GET for registered users' do
    get '/v1/business_reports', {}, auth_session(@business)
    expect(response.status).to eq(403)
  end

end