class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.references :purchaser,        index: true
      t.references :sponsorship,      index: true
      t.decimal :donation_percentage, :precision => 5, :scale => 2, default: 0.00
      t.decimal :amount,              :precision => 15, :scale => 2
      t.string :recipient
      t.string :redemption_code
      t.boolean :redeemed, :default => false

      t.timestamps
    end
  end
end
