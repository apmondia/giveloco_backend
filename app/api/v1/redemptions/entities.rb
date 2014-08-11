module V1
	module Redemptions
		class Entities < Grape::Entity
			expose :id, :documentation => {:type => "integer", :desc => "The database ID of the redemption."}
			expose :voucher_id, :documentation => {:type => "integer", :desc => "The ID of the voucher redeemed."}
			expose :redeemed_by_id, :documentation => {:type => "integer", :desc => "The ID of the user who redeemed the voucher."}
	    	expose :redeemer_name, :documentation => {:type => "string", :desc => "The name of the user who redeemed the voucher."}
	    	expose :vendor_id, :documentation => {:type => "integer", :desc => "The ID of the business that accepted the voucher."}
	    	expose :vendor_name, :documentation => {:type => "string", :desc => "The name of the business that accepted the voucher."}	    	
	    	expose :value, :documentation => {:type => "decimal", :desc => "The value of the voucher."}
	    	expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the redemption occured."}
			expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the redemption was last updated."}
		end
	end
end