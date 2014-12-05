class User::ConfirmationsController < Devise::ConfirmationsController

	def show
		self.resource = resource_class.confirm_by_token(params[:confirmation_token])

		if resource.errors.empty?
			set_flash_message(:notice, :confirmed) if is_navigational_format?
      flash[:status] = 'success'
			sign_in(resource_name, resource)
			respond_with_navigational(resource){
        redirect_to after_confirmation_path_for(resource_name, resource)
      }
    else
      flash[:status] = 'failure'
			flash[:notice] = "Your account is already confirmed. Please login."
			redirect_to after_confirmation_path_for(resource_name, resource)
		end
  end



	protected
	# Redirect to FRONT_END_BASE_URL on confirmation
	def after_confirmation_path_for(resource_name, resource)
    Rails.application.config.front_end_base_url + "/user/confirmation?message=#{URI::escape(flash[:notice])}&status=#{URI::escape(flash[:status])}"
  end

end