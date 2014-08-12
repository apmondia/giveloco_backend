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
			@transaction.created_by = params[:created_by] if params[:created_by]
			@transaction.accepted_by = params[:accepted_by] if params[:accepted_by]
			@transaction.trans_type = params[:trans_type] if params[:trans_type]
			@transaction.from_name = params[:from_name] if params[:from_name]
			@transaction.to_name = params[:to_name] if params[:to_name]
			@transaction.total_debt = params[:total_debt] if params[:total_debt]
			@transaction.total_credit = params[:total_credit] if params[:total_credit]
			@transaction.remaining_debt = params[:remaining_debt] if params[:remaining_debt]
			@transaction.status = params[:status] if params[:status]
			@transaction.active = params[:active] if params[:active]
			@transaction.save 

			status 201
			present @transaction, with: V1::Entities::Transactions
		end

		desc "Update a single transaction"
		put ':id' do
			@transaction = Transaction.find(params[:id])
			@transaction.total_debt = params[:total_debt] if params[:total_debt]
			@transaction.total_credit = params[:total_credit] if params[:total_credit]
			@transaction.remaining_debt = params[:remaining_debt] if params[:remaining_debt]
			@transaction.status = params[:status] if params[:status]
			@transaction.active = params[:active] if params[:active]
			@transaction.save

			present @transaction, with: V1::Entities::Transactions
		end

		# desc "Delete a single transaction"
		# delete ':id' do
		# 	Transaction.destroy(params[:id])
		# end
	end

end # End Class