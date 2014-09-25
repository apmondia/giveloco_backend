module V1::Helpers::UsersHelper
	# Get current user
	def current_user
		env['warden'].user
	end

	# Authenticate user by auth_token and request header
	def authenticate!
		@session_token = request.headers['X-Session-Token']
		@request_user = User.find(params[:id])

		if @request_user.authentication_token == nil
			@auth_token = nil
		else
			@auth_token = @request_user.authentication_token
		end
		
		error!('Unauthorized', 401) unless @session_token == @auth_token && @auth_token != nil
	end

end