require 'net/http'

class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  include V1::Helpers::UsersHelper

  def stripe_connect
    account = Stripe::Account.retrieve(request.env["omniauth.auth"].credentials.token)
    @user = User.find_by_email(account['email'])
    if @user.update_attributes({
                                   provider: request.env["omniauth.auth"].provider,
                                   uid: request.env["omniauth.auth"].uid,
                                   access_code: request.env["omniauth.auth"].credentials.token,
                                   refresh_token: request.env['omniauth.auth'].credentials.refresh_token,
                                   publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key
                               })
      # anything else you need to do in response..
      set_flash_message(:notice, :success, :kind => "Stripe") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to failed_sign_in_path
    end
  end

  protected
  def handle_unverified_request
    super
  end

  def after_omniauth_failure_path_for *args
    super *args
  end

end