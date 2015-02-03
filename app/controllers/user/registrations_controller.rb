class User::RegistrationsController < Devise::RegistrationsController
	before_filter :configure_permitted_parameters
	respond_to :json

	def create
		@user = User.create(create_user_params)

		if @user.errors.empty?
      data = {
          auth_token: @user.authentication_token,
          id: @user.id,
          role: @user.role,
          success: true,
          info: "Account Created"
      }
			render 	status: 201,
					json: data
		else
			render json: {
          :errors => @user.errors.full_messages
      }, status: 422
		end
	end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    super
  end

	# Signs in a user on sign up.
	def sign_up(resource_name, resource)
		sign_in(resource_name, resource)
	end

	def destroy
		resource.soft_delete
		Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
		set_flash_message :notice, :destroyed if is_navigational_format?
		respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
		render 	status: 200,
				json: { 
				auth_token: null,
				success: true,
				info: "User Disabled",
				uid: @user.id
			}
	end

 
	protected

	def create_user_params
		params.require(:user).permit(:role, :email, :password, :first_name, :last_name, :sponsorship_rate,
                                 :company_name, :phone,
                                 :street_address, :city, :state, :country, :zip,
                                 :summary, :description, :website, :profile_picture, :mailing_list_opt_in, :agree_to_tc, :tag_list)
	end

	def change_password_params
		params.require(:user).permit(:password, :password_confirmation, :current_password)
	end
	
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up).push(:role, :email, :password, :first_name, :last_name, :company_name, :phone, :street_address, :city, :state, :country, :zip, :summary, :description, :website, :profile_picture, tag_list: [])
		devise_parameter_sanitizer.for(:account_update)
      .push(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :company_name, :phone, :street_address, :city, :state, :country, :zip, :summary, :description, :website, :profile_picture, :sponsorship_rate, tag_list: [])
  end

end
