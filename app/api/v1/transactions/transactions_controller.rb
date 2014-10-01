class V1::Transactions::TransactionsController < V1::Base
	include V1::Defaults

	# before do
 #    	authenticate!
 #    end

	resource :transactions do

	    desc "Return complete list of transactions"
	    get do
			@transactions = Transaction.all
			present @transactions, with: V1::Transactions::Entities
	    end

	# =======================================================================
	# 	Return lists of transactions by type
	# =======================================================================
	    desc "Return list of donations"
	    get 'type/donation' do
			@donations = Transaction.where("trans_type = 'donation'")
			present @donations, with: V1::Transactions::Entities
	    end

	    desc "Return list of pledges"
	    get 'type/pledge' do
			@pledges = Transaction.where("trans_type = 'pledge'")
			present @pledges, with: V1::Transactions::Entities
	    end

	    desc "Return list of redemptions"
	    get 'type/redemption' do
			@redemptions = Transaction.where("trans_type = 'redemption'")
			present @redemptions, with: V1::Transactions::Entities
	    end

	# =======================================================================
	# 	Return lists of transactions by status
	# =======================================================================
	    desc "Return list of pending transactions"
	    get 'status/pending' do
			@donations = Transaction.where("status = 'pending'")
			present @donations, with: V1::Transactions::Entities
	    end

	    desc "Return list of completed transactions"
	    get 'status/completed' do
			@pledges = Transaction.where("status = 'completed'")
			present @pledges, with: V1::Transactions::Entities
	    end

	    desc "Return list of cancelled transactions"
	    get 'status/cancelled' do
			@redemptions = Transaction.where("status = 'cancelled'")
			present @redemptions, with: V1::Transactions::Entities
	    end

	# =======================================================================
	# 	Return single transaction
	# =======================================================================
	    desc "Return a single transaction"
	    get ':id' do
			@transaction = Transaction.find(params[:id])
			present @transaction, with: V1::Transactions::Entities
		end

	# =======================================================================
	# 	Create a new transaction 
	# 	(the type is automatically defined by the user roles involved)
	# =======================================================================
		desc "Create a new transaction"
		params do
			optional :customer_id, type: Integer
			requires :from_user_id, type: Integer
			requires :to_user_id, type: Integer
			requires :amount
		end
		post do
			create_transaction_params = safe_params(params).permit(:customer_id, :from_user_id, :to_user_id, :amount)
			@transaction = Transaction.new(create_transaction_params)
			@transaction.status = :pending
			@transaction.save 

			status 201
			present @transaction, with: V1::Transactions::Entities
		end


	# =======================================================================
	# 	Make a donation (using Stripe)
	# =======================================================================
		desc "Make a donation using Stripe"
		params do
			optional :customer_id, 	type: Integer
			requires :stripeToken
			requires :from_user_id, type: Integer
			requires :to_user_id, 	type: Integer
			requires :amount
		end
		post '/donation' do
			create_transaction_params = safe_params(params).permit(:customer_id, :stripeToken, :from_user_id, :to_user_id, :amount)
			
			token = params[:stripeToken]
			fromUser = User.find(params[:from_user_id])
			toUser = User.find(params[:to_user_id])

			# Create the charge on Stripe's servers - this will charge the user's card
			begin
				charge = Stripe::Charge.create(
					:amount => params[:amount], # amount in cents
					:currency => currencyRegion(toUser.id),
					:card => token,
					:description => "Individual user donation to a cause."
				)
			rescue Stripe::CardError => e
				# The card has been declined
			end
		end


	# =======================================================================
	# 	Update a single transaction
	# =======================================================================
		desc "Update a single transaction"
		params do
			requires :status
		end
		put ':id' do
			@transaction = Transaction.find(params[:id])
			update_transaction_params = safe_params(params).permit(:status)
			@transaction.update_attributes(update_transaction_params)
			@transaction.save

			present @transaction, with: V1::Transactions::Entities
		end

	end

end # End Class