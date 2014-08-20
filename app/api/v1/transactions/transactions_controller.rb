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
			@transaction = Transaction.new(create_transaction_params)
			@transaction.status = :pending
			@transaction.save 

			status 201
			present @transaction, with: V1::Transactions::Entities
		end

		desc "Update a single transaction"
		put ':id' do
			@transaction = Transaction.find(params[:id])
			@transaction.update_attributes(update_transaction_params)
			@transaction.save

			present @transaction, with: V1::Transactions::Entities
		end

		# desc "Delete a single transaction"
		# delete ':id' do
		# 	Transaction.destroy(params[:id])
		# end
	end

	private

	def create_transaction_params
		params.require(:transaction).permit(:stripe_id, :trans_type, :from_user_id, :to_user_id, :amount, :status)
	end

	def update_transaction_params
		params.require(:transaction).permit(:status)
	end

end # End Class