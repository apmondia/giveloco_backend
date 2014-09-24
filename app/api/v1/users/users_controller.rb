class V1::Users::UsersController < V1::Base
	include V1::Defaults

	resource :users do

	    desc "Return complete list of users"
	    get do
			@users = User.all
			present @users, with: V1::Users::Entities
	    end

	    desc "Return list of causes"
	    get 'role/cause' do
			@causes = User.where("role = 'cause'")
			present @causes, with: V1::Users::Entities
	    end

	    desc "Return list of businesses"
	    get 'role/business' do
			@businesses = User.where("role = 'business'")
			present @businesses, with: V1::Users::Entities
	    end

	    desc "Return list of individuals"
	    get 'role/individual' do
			@individuals = User.where("role = 'individual'")
			present @individuals, with: V1::Users::Entities
	    end


	    desc "Return a single user"
	    get ':id' do
	    	authenticate!
			@user = User.find(params[:id])
			present @user, with: V1::Users::Entities, type: 'single_user'
		end


		desc "Update a single user"
		params do
			requires :id, type: Integer
			requires :first_name
			requires :last_name
			requires :email
			optional :password
			optional :password_confirmation
			optional :current_password
			requires :company_name
			requires :phone
			requires :street_address
			requires :city
			requires :state
			requires :country
			requires :zip
			requires :summary
			requires :description
			requires :website
			optional :tag_list
		end
		put ':id' do
			authenticate!
			@user = User.find(params[:id])

			update_user_params = safe_params(params).permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :company_name, :phone, :street_address, :city, :state, :country, :zip, :summary, :description, :website, tag_list: [])
			@user.update_attributes(update_user_params)
			@user.save

			present @user, with: V1::Users::Entities
		end


		desc "Upload a single user's Profile Picture"
		params do
			requires :id, type: Integer
			requires :profile_picture
		end
		post ':id/upload_image' do
			authenticate!
			upload_picture_params = safe_params(params).permit(:profile_picture)
			@user = User.find(params[:id])

			unless params[:profile_picture].blank?
				profile_picture = params[:profile_picture]

				attachment = {
					:filename => profile_picture[:filename],
					:type => profile_picture[:type],
					:headers => profile_picture[:head],
					:tempfile => profile_picture[:tempfile]
				}

				@user.update_attributes(upload_picture_params)
				@user.profile_picture = ActionDispatch::Http::UploadedFile.new(attachment)
				@user.save
			end

			present @user, with: V1::Users::Entities
		end


		desc "Delete a single user's Profile Picture"
		params do
			requires :id, type: Integer
		end
		delete ':id/delete_image' do
			authenticate!
			@user = User.find(params[:id])
			@user.profile_picture = nil
			@user.save
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

			resource '/tags' do
				desc "Return COMPLETE list of user's Tags"
				get do
					@tags = User.find(params[:id]).tag_counts_on(:tags)
				end
			end
		end

	end

end # End Class

# Example: https://github.com/bloudraak/grape-sample-blog-api-with-entities/blob/master/app/api/blog/api.rb