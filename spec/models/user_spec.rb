require 'rails_helper'

describe User do

  it 'should automatically publish a business if the profile is complete' do

    b = create(:business)
    expect(b.is_published).to eq(true)

    b.access_code = nil
    b.save!
    expect(b.is_published).to eq(false)

  end

  it 'should automatically publish a cause if the profile is complete' do

    c = create(:cause)
    expect(c.is_published).to eq(true)

    c.description = ""
    c.save!
    expect(c.is_published).to eq(false)

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