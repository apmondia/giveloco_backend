require 'rails_helper'

RSpec.describe Sponsorship, :type => :model do

  describe 'It should register as causes for the business' do

    before(:each) do
      @business = create(:business)
      @cause = create(:cause)
      @s = create(:sponsorship, :business => @business, :cause => @cause)
    end

    it 'the association should create' do
      expect(User.find(@business.id).causes).to include(@cause)
      expect(User.find(@cause.id).businesses).to include(@business)
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
