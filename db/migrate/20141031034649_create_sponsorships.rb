class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.references :business, index: true
      t.references :cause, index: true
      t.datetime :resolved_at #the date when the sponsorship was accepted or cancelled
      t.integer :status
      t.decimal :donation_percentage, :precision => 8, :scale => 2, default: 0.00

      t.timestamps
    end
  end
end
