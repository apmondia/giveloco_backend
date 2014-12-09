require 'rails_helper'

describe 'As a user I want to view the causes' do

  before(:each) do
    @b = create(:business)
    @c = create(:cause)
    @s = create(:sponsorship, :business => @b, :cause => @c)
    expect(@b.is_published).to eq(true)
    expect(@c.is_published).to eq(true)

    @b_not_pub = create(:business, :access_code => nil)
    expect(@b_not_pub.is_published).to eq(false)
    @c2 = create(:cause)
    @s = create(:sponsorship, :business => @b_not_pub, :cause => @c2)

  end

  it 'should show all published causes' do

    visit '/'
    click_link 'Explore'
    click_link 'Causes'
    expect(page).to have_content(@c.company_name)
    expect(page).to have_content(@c2.company_name)

  end

end