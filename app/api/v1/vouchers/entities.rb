module V1
	module Vouchers
		class Entities < Grape::Entity
			expose :id, :documentation => {:type => "integer", :desc => "The database ID of the voucher."}
			expose :issued_by_id, :documentation => {:type => "integer", :desc => "The ID of the user (cause) who issued the voucher."}
			expose :issued_by_name, :documentation => {:type => "string", :desc => "The name of the user who issued the voucher."}
			expose :claimed_by_id, :documentation => {:type => "integer", :desc => "The ID of the user (individual) who claimed the voucher."}
	    	expose :claimed_by_name, :documentation => {:type => "integer", :desc => "The name of the user who claimed the voucher."}
	    	expose :max_value, :documentation => {:type => "decimal", :desc => "The maximum redeemable value of the voucher."}
	    	expose :redeemed, :documentation => {:type => "boolean", :desc => "Has the voucher been redeemed? True / False"}
	    	expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the voucher was created."}
			expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the voucher was last updated."}
		end
	end
end