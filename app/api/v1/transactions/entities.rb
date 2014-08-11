module V1
	module Transactions
		class Entities < Grape::Entity
			expose :id, :documentation => {:type => "integer", :desc => "The database ID of the transaction."}
			expose :created_by_id, :documentation => {:type => "integer", :desc => "The user who started the transaction."}
	    	expose :accepted_by_id, :documentation => {:type => "integer", :desc => "The ID of the user who accepted the transaction."}
	    	expose :trans_id, :documentation => {:type => "integer", :desc => "The numeric ID of the transaction."}
			expose :trans_type, :documentation => {:type => "string", :desc => "The type of transaction. Can be PLEDGE or DONATION."}
	    	expose :from_name, :documentation => {:type => "string", :desc => "The ID of the name of the user who started the transaction."}
	    	expose :to_name, :documentation => {:type => "string", :desc => "The name of the user who accepted the transaction."}
	    	expose :total_debt, :documentation => {:type => "decimal", :desc => ""}
	    	expose :total_credit, :documentation => {:type => "decimal", :desc => ""}
	    	expose :remaining_debt, :documentation => {:type => "decimal", :desc => ""}
	    	expose :status, :documentation => {:type => "string", :desc => ""}
	    	expose :active, :documentation => {:type => "boolean", :desc => ""}
	    	expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction occured."}
			expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was last updated."}
		end
	end
end