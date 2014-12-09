require 'rails_helper'

describe 'As a user I want to view the businesses' do

  before(:each) do
    @b = create(:business)
    @c = create(:cause)
    @s1 = create(:sponsorship, :business => @b, :cause => @c)

    @b2 = create(:business)
    @c2 = create(:cause, :description => '')
    expect(@c2.is_published).to eq(false)
    @s2 = create(:sponsorship, :business => @b2, :cause => @c2)

  end

  it 'should show all published businesses' do

    visit '/'
    click_link 'Explore'
    expect(page).to have_content(@b.company_name)
    expect(page).not_to have_content(@b2.company_name)

  end

end