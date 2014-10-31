module V1::Helpers::UsersHelper
	# Get current user
	def current_user
		env['warden'].user
	end

  def cannot? *args
    current_ability.cannot? *args
  end

  def can? *args
    current_ability.can? *args
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end

  # Authenticate user by auth_token and request header
	def authenticate!		
		error!('Unauthorized', 401) unless is_authenticated
	end

	def is_authenticated
		@session_token = request.headers['X-Session-Token']
		@request_user = User.find(params[:id])

		if @request_user.authentication_token == nil
			@auth_token = nil
		else
			@auth_token = @request_user.authentication_token
		end
		(@session_token == @auth_token && @auth_token != nil) ? true : false
  end

end