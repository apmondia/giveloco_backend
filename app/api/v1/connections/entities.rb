module V1
	module Connections
		class Entities < Grape::Entity

			expose :id, :as => :connection_id, :documentation => {:type => "integer", :desc => "The database ID of the connection."}
			expose :from_name, :documentation => {:type => "string", :desc => "The NAME of the user who started the transaction."}
	    	expose :to_name, :documentation => {:type => "string", :desc => "The NAME of the user who accepted the transaction."}
			expose :from_user_id, :documentation => {:type => "integer", :desc => "The ID of the user who created the connection."}
			expose :to_user_id, :documentation => {:type => "integer", :desc => "The ID of the user who accepted the connection."}
			with_options(if: {:type => 'authorized'}) do
				expose :trans_type, :documentation => {:type => "string", :desc => "The connection type based on transaction. Can be PLEDGE, DONATION, or REDEMPTION."}
				expose :is_active, :documentation => {:type => "boolean", :desc => "Determines if the connection is active based on the connection balance."}
				expose :connection_balance, :documentation => {:type => "decimal", :desc => "The remaining balance of the current connection."}#, if: {:type => 'authorized'}
		    	expose :total_transactions, :as => :total_completed_transactions, :documentation => {:type => "integer", :desc => "The total transactions associated with this connection."}
	    	end
	    	expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was started."}
			expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was last updated."}
			expose :trans, as: :transactions, :using => Transactions::Entities::SnapShot, :documentation => {:type => "object", :desc => "The database ID of the transaction."}

			class SnapShot < Grape::Entity
				expose :id, :as => :connection_id
				expose :from_user_id
				expose :to_user_id
				expose :from_name
				expose :to_name
				expose :is_active
			end
		end
	end
end