class V1::Users::UsersController < V1::Base
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
			resource '/transactions' do
				desc "Return COMPLETE list of user's Transactions"
				get do
					@transactions_created_list = User.find(params[:id]).transactions_created + User.find(params[:id]).transactions_accepted
				end
			end

			resource '/transactions_created' do

				desc "Return list of user's CREATED Transactions"
				get do
					@created_transactions_list = User.find(params[:id]).transactions_created
				end

				desc "Return a single transaction CREATED by this user"
				get '/:transaction_id' do
					# @transaction = Transaction.find(params[:id])
					@created_transaction = User.find(params[:id]).transactions_created.find(params[:transaction_id])
				end
			end

			resource '/transactions_accepted' do

				desc "Return list of user's ACCEPTED Transactions"
				get do
					@accepted_transactions_list = User.find(params[:id]).transactions_accepted
				end

				desc "Return a single transaction ACCEPTED by this user"
				get '/:transaction_id' do
					@accepted_transaction = User.find(params[:id]).transactions_accepted.find(params[:transaction_id])
				end
			end
		end

	end

end # End Class

# Example: https://github.com/bloudraak/grape-sample-blog-api-with-entities/blob/master/app/api/blog/api.rb