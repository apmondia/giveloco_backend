require 'rails_helper'

describe User do

  before(:each) do
    @b = create(:business)
    @c = create(:cause)
    @s = create(:sponsorship, :business => @b, :cause => @c)
  end

  it 'should create an authentication token' do
    b = create(:business)
    expect(b.authentication_token).to be
  end

  it 'should publish businesses and causes if their profile is complete' do
    expect(@b.is_published).to eq(true)
    expect(@c.is_published).to eq(true)
  end

  it 'should unpublish businesses that have no sponsorships' do
    @c.update_attributes(:description => nil)
    expect(@c.is_published).to eq(false)
    expect(User.find(@b.id).is_published).to eq(false)
  end

  it 'should ignore banking info' do
    @b.update_attributes({:access_code => nil})
    expect(@b.is_published).to eq(true)
    @b.update_attributes({:access_code => '1234'})
    expect(@b.is_published).to eq(true)
  end

  it 'should automatically publish a cause if the profile is complete' do

    c = create(:cause)
    expect(c.is_published).to eq(true)

    c.description = ""
    c.save!
    expect(c.is_published).to eq(false)

    c2 = create(:cause)
    c2.description = ""
    c2.save!
    expect(c2.is_published).to eq(false)

    c2.update_attributes({:description => 'Foobar'})
    expect(c2.is_published).to eq(true)

  end

  it 'should automatically activate businesses and causes if they have sponsorships' do

    c = create(:cause)
    expect(c.is_activated).to eq(false)

    b = create(:business)
    expect(b.is_activated).to eq(false)

    s = create(:sponsorship, :business => b, :cause => c)
    expect(b.is_activated).to eq(true)
    expect(c.is_activated).to eq(true)

    s.destroy

    expect(b.is_activated).to eq(false)
    expect(c.is_activated).to eq(false)

  end

end