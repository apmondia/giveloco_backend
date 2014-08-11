class Voucher < ActiveRecord::Base
	belongs_to 	:issued_by, :class_name => "User", :foreign_key => "issued_by_id"
	belongs_to 	:claimed_by, :class_name => "User", :foreign_key => "claimed_by_id"
	has_many	:redemptions
end
