class Redemption < ActiveRecord::Base
	belongs_to :voucher
	belongs_to :vendor, :class_name => "User", :foreign_key => "vendor_id"
    belongs_to :redeemed_by, :class_name => "User", :foreign_key => "redeemed_by_id"
end
