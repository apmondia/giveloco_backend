module V1::Helpers::UsersHelper

	SESSION_TOKEN_HEADER = 'X-Session-Token'

	def user_from_session
		@session_token = request.headers[SESSION_TOKEN_HEADER]
		User.where(:authentication_token => @session_token).first if !@session_token.nil?
	end

	# Get current user
	def current_user
		@session_user = @session_user || env['warden'].user || user_from_session
	end

	def cannot? *args
		current_ability.cannot? *args
	end

	def can? *args
		current_ability.can? *args
	end

	def can_or_die *args
		result = can? *args
		if !result
			error!('Forbidden', 403)
		end
	end

	def current_ability
		@current_ability ||= Ability.new(current_user, params)
	end

  # Authenticate user by auth_token and request header
  # can pass :user_id to ensure the user is either admin or that user.
	def authenticate!
		error!('Unauthorized', 401) if !is_authenticated
	end

	def is_authenticated
		@request_user = user_from_session
    @auth_token = @request_user.try(:authentication_token) || nil
		!@auth_token.nil?
	end

	def is_admin
		user_from_session.try(:'admin?') == true
	end

end