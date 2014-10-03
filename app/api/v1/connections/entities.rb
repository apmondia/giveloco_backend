module V1
	module Connections
		class Entities < Grape::Entity
			expose :id, :documentation => {:type => "integer", :desc => "The database ID of the connection."}
			expose :trans_id, as: :transaction_id, :documentation => {:type => "integer", :desc => "The database ID of the transaction."}
			expose :trans_type, :documentation => {:type => "string", :desc => "The connection type based on transaction. Can be PLEDGE, DONATION, or REDEMPTION."}
			expose :from_connection_id, :documentation => {:type => "integer", :desc => "The ID of the user who created the connection."}
	    	expose :to_connection_id, :documentation => {:type => "integer", :desc => "The ID of the user who accepted the connection."}
	    	expose :connection_balance, :documentation => {:type => "decimal", :desc => "The remaining balance of the current connection."}
	    	expose :is_active, :documentation => {:type => "boolean", :desc => "Determines if the connection is active based on the connection balance."}
	    	expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was started."}
			expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was last updated."}
		end
	end
end