class AddSponsorshipRateToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.decimal  "sponsorship_rate", precision: 15, scale: 2, default: 10.0
    end
  end
end
