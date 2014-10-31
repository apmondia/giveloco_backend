class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.references :from_user, index: true
      t.references :to_user, index: true
      t.string :status
      t.decimal :donation_percentage, :precision => 8, :scale => 2, default: 0.00

      t.timestamps
    end
  end
end
