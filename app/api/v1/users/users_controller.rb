class V1::Users::UsersController < V1::Base

	resource :users do

	    desc "Return complete list of users"
	    get do
        @users = User.all
        if is_admin
          present @users, with: V1::Users::Entity, type: 'authorized'
        else
          present @users, with: V1::Users::Entity
        end
      end

	# =======================================================================
	# 	Return lists of users by role
	# =======================================================================
	    desc "Return list of causes"
	    get 'role/cause' do
			@causes = User.where("role = 'cause'")
			present @causes, with: V1::Users::Entity
	    end

	    desc "Return list of businesses"
	    get 'role/business' do
			@businesses = User.where("role = 'business'")
			present @businesses, with: V1::Users::Entity
	    end

	    desc "Return list of individuals"
	    get 'role/individual' do
			@individuals = User.where("role = 'individual'")
			present @individuals, with: V1::Users::Entity
	    end

	# =======================================================================
	# 	Get single user (requires authentication)
	# =======================================================================
	    desc "Return a single user"
	    get ':id' do
	    	# authenticate!
			@user = User.find(params[:id])
			if (is_authenticated && can?(:read, @user)) || is_admin
				present @user, with: V1::Users::Entity, type: 'authorized'
			else
				present @user, with: V1::Users::Entity
			end
		end

	# =======================================================================
	# 	Update single user
	# =======================================================================
		desc "Update a single user"
		params do
			requires :id, type: Integer
			optional :first_name
			optional :last_name
			optional :email
			optional :password
			optional :password_confirmation
			optional :current_password
			optional :company_name
			optional :phone
			optional :street_address
			optional :city
			optional :state
			optional :country
			optional :zip
			optional :summary
			optional :description
			optional :website
			optional :tag_list
		end
		put ':id' do
			authenticate!
			@user = User.find(params[:id])
      		can_or_die :update, @user
			# safe_params function is in the helpers.rb file
			update_user_params = safe_params(params).permit([:email,
                                                      :password, :password_confirmation, :current_password,
                                                      :first_name, :last_name,
                                                      :company_name, :phone,
                                                      :street_address, :city, :state, :country, :zip,
                                                      :summary, :description, :website,
                                                      (:is_activated if current_user.admin?),
                                                      tag_list: []].compact )

			@user.update_attributes(update_user_params)
			present @user, with: V1::Users::Entity
		end

	# =======================================================================
	# 	User image upload
	# =======================================================================
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

			present @user, with: V1::Users::Entity
		end

	# =======================================================================
	# 	Delete user's profile picture
	# =======================================================================
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

    resource '/certificates' do
      desc 'Purchases a new gift certificate for an anonymous user'
      post do
        user = User.create!(
            safe_params(params).require(:newUser).permit(:email, :first_name, :last_name, :certificates_attributes => [:sponsorship_id, :amount, :stripeToken])
        )
        user
      end
    end

	# =======================================================================
	# 	Return single user's transactions and tags (requires authentication)
	# =======================================================================
		segment '/:id' do

      resource '/certificates' do
        desc 'Returns the list of certificates purchased by this user'
        get do
          authenticate!
          can_or_die :read, Certificate, { :user_id => params[:id].to_i }
          @certificates = User.find(params[:id]).certificates
          present @certificates, :with => V1::Certificates::Entity
        end
      end

      resource '/sponsorships' do
        desc 'Returns a list of sponsorships for this business'
        get do
          can_or_die :read, Sponsorship
          @sponsorships = User.find(params[:id]).sponsorships
          present @sponsorships, :with => V1::Sponsorships::Entity
        end

        resource '/certificates' do
          desc 'Returns all of the certificates for this business'
          get do
            @certificates = User.find(params[:id]).purchased_certificates
            present @certificates, :with => V1::Certificates::Entity
          end
        end

      end

      resource '/sponsors' do
        desc 'Returns the list of sponsorships for this cause'
        get do
          @sponsors = User.find(params[:id]).sponsors
          present @sponsors, :with => V1::Sponsorships::Entity
        end

        resource '/certificates' do
          desc 'Returns all of the gift certificates purchased for this cause'
          get do
            @certificates = User.find(params[:id]).sponsor_certificates
            present @certificates, :with => V1::Certificates::Entity
          end
        end
      end

			resource '/transactions' do
				desc "A list of certificates that have been purchased for this business"
				get do
          authenticate!
					@certificates = Certificate.for_business( current_user )
					present @certificates, with: V1::Certificates::Entity
        end
			end

      resource '/donations' do
        desc 'A list of certificates that donate to this cause'
        get do
          authenticate!
          @certificates = Certificate.for_cause( current_user )
          present @certificates, with: V1::Certificates::Entity
        end
      end

			resource '/transactions_created' do

				desc "Return list of user's CREATED Transactions"
				get do
					@created_transactions_list = User.find(params[:id]).transactions_created
					present @created_transactions_list, with: V1::Transactions::Entities
				end

				desc "Return a single transaction CREATED by this user"
				get '/:transaction_id' do
					@created_transaction = User.find(params[:id]).transactions_created.find(params[:transaction_id])
					present @created_transaction, with: V1::Transactions::Entities
				end
			end

			resource '/transactions_accepted' do

				desc "Return list of user's ACCEPTED Transactions"
				get do
					@accepted_transactions_list = User.find(params[:id]).transactions_accepted
					present @accepted_transactions_list, with: V1::Transactions::Entities
				end

				desc "Return a single transaction ACCEPTED by this user"
				get '/:transaction_id' do
					@accepted_transaction = User.find(params[:id]).transactions_accepted.find(params[:transaction_id])
					present @accepted_transaction, with: V1::Transactions::Entities
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