class V1::Users::Users < V1::Base
	include V1::Defaults

	resource :users do

	    desc "Return list of users"
	    get do
			@users = User.all
			present @users, with: V1::Users::Entities
	    end

	    desc "Return a single user"
	    get ':id' do
			@user = User.find(params[:id])
			present @user, with: V1::Users::Entities
		end

		segment '/:id' do
			resource '/transactions_created' do

				desc "Return list of user's CREATED Transactions"
				get do
					@created_transactions_list = User.find(params[:id]).transactions_created
				end

				desc "Return a single transaction CREATED by this user"
				get '/:trans_id' do
					# @transaction = Transaction.find(params[:id])
					@created_transaction = User.find(params[:id]).transactions_created.find(params[:trans_id])
				end
			end

			resource '/transactions_accepted' do

				desc "Return list of user's ACCEPTED Transactions"
				get do
					@accepted_transactions_list = User.find(params[:id]).transactions_accepted
				end

				desc "Return a single transaction ACCEPTED by this user"
				get '/:trans_id' do
					@accepted_transaction = User.find(params[:id]).transactions_accepted.find(params[:trans_id])
				end
			end

			resource '/vouchers_issued' do

				desc "Return list of user's ISSUED Vouchers"
				get do
					@issued_voucher_list = User.find(params[:id]).vouchers_issued
				end

				desc "Return a single Voucher ISSUED by this user"
				get '/:voucher_id' do
					@issued_voucher = User.find(params[:id]).vouchers_issued.find(params[:voucher_id])
				end
			end

			resource '/vouchers_claimed' do

				desc "Return list of user's CLAIMED Vouchers"
				get do
					@claimed_voucher_list = User.find(params[:id]).vouchers_claimed
				end

				desc "Return a single Voucher CLAIMED by this user"
				get '/:voucher_id' do
					@claimed_voucher = User.find(params[:id]).vouchers_claimed.find(params[:voucher_id])
				end
			end

			resource '/redemptions' do

				desc "Return list of user's REDEEMED Vouchers"
				get do
					@redeemed_voucher_list = User.find(params[:id]).redemptions
				end

				desc "Return a single Voucher REDEEMED by this user"
				get '/:voucher_id' do
					@redeemed_voucher = User.find(params[:id]).redemptions.find(params[:voucher_id])
				end
			end
		end

	end

end # End Class

# Example: https://github.com/bloudraak/grape-sample-blog-api-with-entities/blob/master/app/api/blog/api.rb