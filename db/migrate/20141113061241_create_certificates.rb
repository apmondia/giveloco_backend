class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.references :purchaser, index: true
      t.references :sponsorship, index: true
      t.decimal :donation_percentage
      t.decimal :amount
      t.string :recipient

      t.timestamps
    end
  end
end
