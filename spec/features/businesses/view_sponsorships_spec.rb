require 'rails_helper'

describe 'As a business I want to view my list of sponsorships' do

  include Support::Auth

  before(:each) do
    @b = create(:business)
    @c = create(:cause)
    @s = create(:sponsorship, :business => @b, :cause => @c, :status => Sponsorship.statuses[:accepted])
  end

  it 'should display a list of accepted sponsorships' do
    login(@b)
    expect(page).to have_content(@b.company_name)
    expect(page).to have_content(@c.company_name)
  end

end