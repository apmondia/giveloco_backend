require 'rails_helper'

describe "As an admin I want to change the profile image of a business" do

  before(:each) do
    @admin = create(:admin)
    @business = create(:business)
    @sponsorship = create(:sponsorship, :business => @business, :status => :accepted)
  end

  it 'should allow the admin to change the business profile image' do

    visit_root
    login(@admin)
    open_businesses
    expect(page).to have_content(@business.company_name)
    open_tool_menu
    click_link 'Edit Profile'
    expect(page).to have_content("Editing #{@business.company_name}")
    expect(page).to have_css("input[type='file']")
    attach('captain-kirk-william-shatner.jpg')
    click_link_or_button "upload"
    expect(page).to have_content('Your file was successfully uploaded')

    visit_root
    expect(page).to have_css("img[src*='captain-kirk']")

  end

end