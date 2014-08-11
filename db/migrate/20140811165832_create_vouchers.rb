class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
    	t.belongs_to 	:issued_by, :class_name => "User", :foreign_key => "issued_by_id"
		t.belongs_to 	:claimed_by, :class_name => "User", :foreign_key => "claimed_by_id"

    	t.string		:issued_by_name
    	t.string		:claimed_by_name
    	t.decimal		:max_value, :precision => 8, :scale => 2
    	t.boolean		:redeemed

    	t.timestamps
    end
  end
end
