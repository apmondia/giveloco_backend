require 'net/http'

class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  include UserAuth

  def stripe_connect
    @user = get_current_user
    access_token_uri = URI('https://connect.stripe.com/oauth/token')
    res = Net::HTTP.post_form(access_token_uri, {
        :client_secret => Rails.application.config.stripe_secret_key,
        :code => params[:code],
        :grant_type => 'authorization_code'
    })
    body = res.body
    body_json = JSON.parse(body)
    puts body_json
    response = {}
    if (body_json['error'])
      status = 422
      response[:error] = body_json['error_description']
    elsif @user.update_attributes({
       provider: :stripe_connect,
       uid: body_json['stripe_user_id'],
       access_code: body_json['access_token'],
       publishable_key: body_json['stripe_publishable_key']
                                  })
      status = 201
      response[:message] = 'ok'
    else
      status = 422
      response[:error] = @user.errors.full_messages
    end

    logger.debug("stripe_connect response: "+ response.to_json);

    render :json => {
      :data => response,
      :status => status
    }, :status => status

    # if @user.update_attributes({
    #                                provider: request.env["omniauth.auth"].provider,
    #                                uid: request.env["omniauth.auth"].uid,
    #                                access_code: request.env["omniauth.auth"].credentials.token,
    #                                refresh_token: request.env['omniauth.auth'].credentials.refresh_token,
    #                                publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key
    #                            })
    #   # anything else you need to do in response..
    #   set_flash_message(:notice, :success, :kind => "Stripe") if is_navigational_format?
    #   sign_in_and_redirect @user, :event => :authentication
    # else
    #   session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
    #   redirect_to failed_sign_in_path
    # end
  end

  protected
  def handle_unverified_request
    super
  end

  def after_omniauth_failure_path_for *args
    super *args
  end

end