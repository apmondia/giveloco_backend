module V1::Helpers
	# Get current user
	def current_user
		env['warden'].user
	end
	
	def authenticate!
		@request_user = User.find(params[:id])
		@auth_token = @request_user.authentication_token
		@session_token = request.headers['X-Session-Token']

		error!('Unauthorized', 401) unless @session_token == @auth_token
	end

	# Define Strong Parameters for Rails app
	def safe_params(params)
		ActionController::Parameters.new(params)
	end
end