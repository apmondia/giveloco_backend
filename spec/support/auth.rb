module Support
  module Auth
    def auth_session(user)
      {
          V1::Helpers::UsersHelper::SESSION_TOKEN_HEADER => user.authentication_token
      }
    end
  end
end