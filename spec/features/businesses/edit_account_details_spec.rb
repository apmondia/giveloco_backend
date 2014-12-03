require 'rails_helper'

describe 'As a business I want to edit my account details' do

  before(:each) do
    assert_front_end_up
    @business = create(:business)
  end

  it 'should work' do

    login(@business)
    open_my_profile
    click_link 'Edit Profile'
    fill_in :userPhone, :with => '250 345 2345'
    fill_in :userStreetAddress, :with => '1234 Evergreen Terrace'
    fill_in :userCity, :with => 'Vancouver'
    fill_in :userZip, :with => 'V7E3O9'
    fill_in :userWebsite, :with => 'http://www.google.com'
    fill_in :userDescription, :with => 'Blarg asldfkja sldfkja sdlfkajsdf laksjdf laskfjea lsekfja slekfjas lefkjaslegijaslegija slegijas legija sleigja sleigj asliegj alsiegj alsiegj alsiej glasiejglasiej glaisej glasiej glaisje glaisj eglaisj eglaisj egalsiegj lasiej galsiej galsiegj asliegj alsiegj alsiegj Blarg asldfkja sldfkja sdlfkajsdf laksjdf laskfjea lsekfja slekfjas lefkjaslegijaslegija slegijas legija sleigja sleigj asliegj alsiegj alsiegj alsiej glasiejglasiej glaisej glasiej glaisje glaisj eglaisj eglaisj egalsiegj lasiej galsiej galsiegj asliegj alsiegj alsiegj Blarg asldfkja sldfkja sdlfkajsdf laksjdf laskfjea lsekfja slekfjas lefkjaslegijaslegija slegijas legija sleigja sleigj asliegj alsiegj alsiegj alsiej glasiejglasiej glaisej glasiej glaisje glaisj eglaisj eglaisj egalsiegj lasiej galsiej galsiegj asliegj alsiegj alsiegj Blarg asldfkja sldfkja sdlfkajsdf laksjdf laskfjea lsekfja slekfjas lefkjaslegijaslegija slegijas legija sleigja sleigj asliegj alsiegj alsiegj alsiej glasiejglasiej glaisej glasiej glaisje glaisj eglaisj eglaisj egalsiegj lasiej galsiej galsiegj asliegj alsiegj alsiegj '
    expect(page).to have_content("Editing #{@business.company_name}")
    click_link_or_button 'Save Changes'
    expect(page).to have_content('Your account information was successfully updated.')

  end

end