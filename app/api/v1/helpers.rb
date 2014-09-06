module V1::Helpers
	# Get current user
	def current_user
		env['warden'].user
	end

	# Ensure user is authenticated before continuing
	def authenticate!
		if env['warden'].authenticated?
			return true
		else
			error!('401 Unauthorized', 401)
		end
	end

	# Define Strong Parameters for Rails app
	def safe_params(params)
		ActionController::Parameters.new(params)
	end
end