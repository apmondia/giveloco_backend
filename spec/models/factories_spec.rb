require 'rails_helper'

describe 'Factories' do

  it 'should create a certificate' do
    expect( create(:certificate).valid? ).to eq(true)
  end

  it 'should create a sponsorship' do
    expect( create(:sponsorship).valid? ).to eq(true)
  end

  it 'should create a user' do
    expect( create(:user).valid? ).to eq(true)
  end

end