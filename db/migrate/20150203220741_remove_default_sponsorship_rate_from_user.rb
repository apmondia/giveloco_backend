class RemoveDefaultSponsorshipRateFromUser < ActiveRecord::Migration
  def change
    change_column_default(:users, :sponsorship_rate, nil)
  end
end
