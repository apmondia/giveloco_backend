require 'rails_helper'

describe 'As an admin I want to login' do

  include Support::Auth

  before(:each) do
    assert_front_end_up
    @admin = create(:admin)
  end

  it 'should allow the admin to login' do

    login(@admin)
    expect(page).to have_content(@admin.first_name)

  end

end