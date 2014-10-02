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
			requires :stripeToken
			requires :from_user_id, type: Integer
			requires :to_user_id, 	type: Integer
			requires :amount
		end
		post '/donation' do
			# stripe_transaction_params = safe_params(params).permit(:stripeToken, :from_user_id, :to_user_id, :amount, :route_info)
			create_transaction_params = safe_params(params).permit(:from_user_id, :to_user_id, :amount)
			
			token = params[:stripeToken]
			fromUser = User.find(params[:from_user_id])
			toUser = User.find(params[:to_user_id])

			# =======================================================================
			# 	Stripe Transaction
			# =======================================================================
			begin
				if fromUser.customer_id == nil
				# Create new Stripe customer
					customer = Stripe::Customer.create(
						:card => token,
						:description => "New customer created from Donation."
					)
					# Save stripe customer ID
					fromUser.update_attributes(:customer_id => customer.id)
					fromUser.save					
				end
				# Charge customer's credit card
				charge = Stripe::Charge.create(
					:amount   => params[:amount].to_i * 100, # convert amount to cents
					:currency => currencyRegion(toUser.id),
					:customer => fromUser.customer_id || customer.id
				)
			rescue Stripe::CardError => e
				# The card has been declined
				body = e.json_body
				err  = body[:error]

				puts "Status is: #{e.http_status}"
				puts "Type is: #{err[:type]}"
				puts "Code is: #{err[:code]}"
				puts "Param is: #{err[:param]}"
				puts "Message is: #{err[:message]}"
			end

			# =======================================================================
			# 	Taliflo Database Transaction (Donation)
			# =======================================================================
			@transaction = Transaction.new(create_transaction_params)
			@transaction.stripe_transaction_id = charge.id
			@transaction.status = :complete
			@transaction.save 

			status 201
			present @transaction, with: V1::Transactions::Entities
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