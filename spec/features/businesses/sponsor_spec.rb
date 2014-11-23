require 'rails_helper'

describe 'As a business I want to sponsor a cause' do

  include Support::Auth

  before(:each) do
    @b = create(:business)
    @c = create(:cause)
    login(@b)
  end

  it 'should allow a business to sponsor a cause' do

    expect(page).to have_content('Causes')
    click_link 'Causes'
    expect(page).to have_content(@c.company_name)
    click_link @c.company_name
    expect(page).to have_content('Terms of Service')
    expect(page).to have_content('Privacy Policy')
    find('a.pledge.btn').click
    expect(page).to have_content('Sponsor')

    raise 'This does not appear to be implemented'
  end

end