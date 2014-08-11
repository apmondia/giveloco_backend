class CreateRedemptions < ActiveRecord::Migration
  def change
    create_table :redemptions do |t|
    	t.belongs_to	:voucher
    	t.belongs_to 	:vendor, :class_name => "User", :foreign_key => "vendor_id"
    	t.belongs_to 	:redeemed_by, :class_name => "User", :foreign_key => "redeemed_by_id"

    	t.string		:redeemer_name
    	t.string		:vendor_name
    	t.decimal		:value, :precision => 8, :scale => 2

		t.timestamps
    end
  end
end
