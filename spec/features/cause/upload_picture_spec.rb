require 'rails_helper'

describe 'As a cause I want to upload my profile picture' do

  before(:each) do
    @c = create(:cause)
  end

  def goto_edit_details
    login(@c)
    click_link "Hi, #{@c.first_name}"
    click_link 'My Account'
    click_link 'Edit Details'
    expect(page).to have_css('input[type="file"]')
  end

  def attach(fixture_name)
    page.attach_file 'profile-picture-upload', Rails.root.join('spec','fixtures',fixture_name)
  end

  it 'should allow them to upload a photo' do
    goto_edit_details
    attach('captain-kirk-william-shatner.jpg')
    find_button('upload').click
    expect(page).to have_content('Your file was successfully uploaded')
    expect(page).to have_css(".user-profile-picture img[src='#{User.find(@c.id).profile_picture.url(:medium)}']")
  end

  it 'should not allow them to upload a small photo' do
    goto_edit_details
    attach('pitt.png')
    find_button('upload').click
    expect(page).to have_content("width must be greater than")
    expect(page).to have_content("height must be greater than")
  end

end