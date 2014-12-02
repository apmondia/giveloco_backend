module Support
  module Auth
    def auth_session(user)
      {
          V1::Helpers::UsersHelper::SESSION_TOKEN_HEADER => user.authentication_token
      }
    end

    def login(user)
      visit '/'
      find('footer a.login').click
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      find('form button[type="submit"]').click
      #expect(page).to have_content(user.first_name)
      expect(page).to have_content("You have successfully logged in")
      find('button.close').click
    end
    def logout(user)
      click_link "Hi, #{user.first_name}"
      click_link 'Log Out'
    end
  end

end