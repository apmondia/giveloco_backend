class Voucher < ActiveRecord::Base
	belongs_to 	:user
	has_many	:redemptions
end
