require 'rails_helper'

RSpec.describe Sponsorship, :type => :model do

  describe 'It should register as causes for the business' do

    before(:each) do
      @business = create(:business)
      @cause = create(:cause)
      @s = create(:sponsorship, :business => @business, :cause => @cause, :status => :accepted)
      @s2 = create(:sponsorship, :cause => @cause)
    end

    it 'the association should create' do
      coz = User.find(@cause.id)
      expect(User.find(@business.id).causes).to include(@cause)
      expect(coz.businesses).to include(@business)
      expect(coz.businesses).to_not include(@s2.business)
    end

    it 'should recognize multiple sponsorships' do
      create_list(:sponsorship, 3, :business => @business)
      expect(@business.causes.size).to eq(4)
    end

    it 'destroying a business will destroy the sponsorships' do
      @business.destroy
      expect( User.find(@cause.id).businesses).to be_empty
    end

  end

end
