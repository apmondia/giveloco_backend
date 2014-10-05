module V1
	module Transactions
		class Entities < Grape::Entity
			format_with :timestamp do |date|
				date.strftime('%B %d, %Y') unless date == nil
			end

			expose :id, :documentation => {:type => "integer", :desc => "The database ID of the transaction."}
	    	expose :trans_type, :documentation => {:type => "string", :desc => "The type of transaction. Can be PLEDGE, DONATION, or REDEMPTION."}
	    	expose :trans_id, :documentation => {:type => "integer", :desc => "The numeric ID of the transaction."}
	    	expose :stripe_transaction_id, :documentation => {:type => "string", :desc => "The numeric ID of the Braintree Payments transaction (if one exists)."}
			expose :amount, :documentation => {:type => "decimal", :desc => "The financial value of the transaction"}
			expose :from_user_id, :documentation => {:type => "integer", :desc => "The ID of the user who started the transaction."}
	    	expose :to_user_id, :documentation => {:type => "integer", :desc => "The ID of the user who accepted the transaction."}
	    	expose :from_name, :documentation => {:type => "string", :desc => "The NAME of the user who started the transaction."}
	    	expose :to_name, :documentation => {:type => "string", :desc => "The NAME of the user who accepted the transaction."}
	    	expose :from_user_role, :documentation => {:type => "string", :desc => "The ROLE of the user who started the transaction."}
	    	expose :to_user_role, :documentation => {:type => "string", :desc => "The ROLE of the user who accepted the transaction."}
	    	expose :from_user_balance, :documentation => {:type => "decimal", :desc => "The running balance of the user who STARTED the transaction"}
	    	expose :to_user_balance, :documentation => {:type => "decimal", :desc => "The running balance of the user who ACCEPTED the transaction"}
	    	expose :status, :documentation => {:type => "string", :desc => "The status of the transaction. Can be PENDING, CANCELLED, or COMPLETED"}
	    	with_options(format_with: :timestamp) do
		    	expose :cancelled_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was CANCELLED."}
		    	expose :completed_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was COMPLETED."}
		    	expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was started."}
				expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was last updated."}
			end

			class SnapShot < Grape::Entity
				expose :id
				expose :trans_type
				expose :status
			end
		end
	end
end