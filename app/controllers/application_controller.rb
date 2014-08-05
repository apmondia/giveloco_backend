class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session
	respond_to :html, :json

	after_filter :set_csrf_cookie_for_ng

	def set_csrf_cookie_for_ng
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
	end

	rescue_from ActionController::InvalidAuthenticityToken do |exception|
		sign_out(current_user)
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
		render :error => 'invalid token', :status => :unprocessable_entity
	end

	protected
	def verified_request?
		super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
	end
end
