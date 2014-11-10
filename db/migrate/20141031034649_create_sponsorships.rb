class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.references :business, index: true
      t.references :cause, index: true
      t.string :status
      t.decimal :donation_percentage, :precision => 8, :scale => 2, default: 0.00

      t.timestamps
    end
  end
end
