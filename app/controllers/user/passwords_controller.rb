class User::PasswordsController < Devise::PasswordsController
	respond_to :json

	protected
	def after_sending_reset_password_instructions_path_for(resource_name)
		#return your path
		ENV["FRONT_END_BASE_URL"]
	end
end