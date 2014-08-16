class V1::Transactions::TransactionsController < V1::Base
	include V1::Defaults

	resource :transactions do

	    desc "Return list of transactions"
	    get do
			@transactions = Transaction.all
			present @transactions, with: V1::Transactions::Entities
	    end

	    desc "Return a single transaction"
	    get ':id' do
			@transaction = Transaction.find(params[:id])
			present @transaction, with: V1::Transactions::Entities
		end

		desc "Create a new transaction"
		post do
			@transaction = Transaction.new
			@transaction.trans_id = @transaction.create_id
			@transaction.stripe_id = params[:stripe_id] if params[:stripe_id]
			@transaction.trans_type = params[:trans_type] if params[:trans_type]
			@transaction.from_user_id = params[:from_user_id] if params[:from_user_id]
			@transaction.to_user_id = params[:to_user_id] if params[:to_user_id]
			@transaction.from_name = User.get_user_name(params[:from_user_id])
			@transaction.to_name = User.get_user_name(params[:to_user_id])
			@transaction.from_user_role = User.get_user_role(params[:to_user_id])
			@transaction.to_user_role = User.get_user_role(params[:to_user_id])
			@transaction.amount = params[:amount] if params[:amount]
			@transaction.status = :pending
			@transaction.save 

			status 201
			present @transaction, with: V1::Transactions::Entities
		end

		desc "Update a single transaction"
		put ':id' do
			@transaction = Transaction.find(params[:id])
			@transaction.status = params[:status] if params[:status]
			if params[:status] == :cancelled
				Transaction.cancelled
			end
			if params[:status] == :complete
				Transaction.complete
			end
			@transaction.save

			present @transaction, with: V1::Transactions::Entities
		end

		# desc "Delete a single transaction"
		# delete ':id' do
		# 	Transaction.destroy(params[:id])
		# end
	end

end # End Class