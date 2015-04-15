require 'rails_helper'

describe 'As a cause I want to upload my profile picture' do

  before(:each) do
    @c = create(:cause)
  end

  it 'should allow them to upload a photo' do
    login(@c)
    goto_edit_profile(@c)
    attach('captain-kirk-william-shatner.jpg')
    find_button('upload').click
    expect(page).to have_content('Your file was successfully uploaded')
    expect(page).to have_css(".profile-image[style*='#{User.find(@c.id).profile_picture.url(:medium)}']")
  end

  #we removed restrictions here
  # it 'should not allow them to upload a small photo' do
  #   goto_edit_profile
  #   attach('pitt.png')
  #   find_button('upload').click
  #   expect(page).to have_content("width must be greater than")
  #   expect(page).to have_content("height must be greater than")
  # end

end