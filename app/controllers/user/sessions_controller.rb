class User::SessionsController < Devise::SessionsController
	skip_before_filter :verify_signed_out_user
	before_filter :configure_permitted_parameters
	before_filter :authenticate_user_from_token!, except: [:create]
	after_filter :set_csrf_headers, only: [:create, :destroy]

	def create
		user = User.find_for_database_authentication(email: params[:email])
		if user && user.valid_password?(params[:password])
			token = user.ensure_authentication_token
			render 	status: 200,
					json: { 
				auth_token: token,
				success: true,
				info: "Logged in",
				uid: user.id
			}
		else
			render nothing: true, status: :unauthorized
		end
	end

	def destroy
		current_user.authentication_token = nil
		current_user.save!
		render 	status: 200, 
				json: {
					success: true,
					info: "Logged out"
				}
	end

	protected
	def set_csrf_headers
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?  
	end
	
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_in) do |u|
		  u.permit(:email, :password)
		end
	end
end