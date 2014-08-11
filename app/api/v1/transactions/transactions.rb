class V1::Transactions::Transactions < V1::Base
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
			@transaction.first_name = params[:first_name] if params[:first_name]
			@transaction.last_name = params[:last_name] if params[:last_name]
			@transaction.save 

			status 201
			present @transaction, with: Transaction::Entities::Transactions
		end

		desc "Update a single transaction"
		put ':id' do
			@transaction = Transaction.find(params[:id])
			@transaction.first_name = params[:first_name] if params[:first_name]
			@transaction.last_name = params[:last_name] if params[:last_name]
			@transaction.save

			present @transaction, with: Transaction::Entities::Transactions
		end

		desc "Delete a single transaction"
		delete ':id' do
			Transaction.destroy(params[:id])
		end
	end

end # End Class