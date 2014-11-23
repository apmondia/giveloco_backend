module Support
  module Auth
    def auth_session(user)
      {
          V1::Helpers::UsersHelper::SESSION_TOKEN_HEADER => user.authentication_token
      }
    end

    def login(user)
      visit '/'
      click_link 'Log In'
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      find('form button[type="submit"]').click
      expect(page).to have_content(@b.company_name)
    end
  end
end