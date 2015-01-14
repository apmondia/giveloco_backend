class RemoveDonationPercentageFromSponsorships < ActiveRecord::Migration
  def change
    remove_column :sponsorships, :donation_percentage, :type => :decimal
  end
end
