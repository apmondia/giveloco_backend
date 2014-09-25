class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
	respond_to :json

	before_filter :make_action_mailer_use_request_host_and_protocol
	after_filter :set_csrf_cookie_for_ng

	# Authenticate user based on token
	def authenticate_user_from_token!
		token = request.headers["x-session-token"].presence
		user = token && User.find_by_authentication_token(token.to_s)
		if user
			sign_in user, store: false
		end
	end

	# CSRF protection when using AngularJS
	def set_csrf_cookie_for_ng
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
	end

	rescue_from ActionController::InvalidAuthenticityToken do |exception|
		sign_out(current_user)
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
		render :error => 'invalid token', :status => :unprocessable_entity
	end

	private
	# Automatically sets base url for action mailer
	def make_action_mailer_use_request_host_and_protocol
		ActionMailer::Base.default_url_options[:protocol] = request.protocol
		ActionMailer::Base.default_url_options[:host] = request.host_with_port
	end

	protected
	def verified_request?
		super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
	end
end
