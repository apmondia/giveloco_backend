class ChangeColumnTypeOfSponsorshipRate < ActiveRecord::Migration
  def change
    change_column :users, :sponsorship_rate, :integer
  end
end
