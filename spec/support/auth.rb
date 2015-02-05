module Support
  module Auth
    def auth_session(user)
      if user
        {
            V1::Helpers::UsersHelper::SESSION_TOKEN_HEADER => user.authentication_token
        }
      else
        {}
      end
    end

    def expect_confirmation_email(recipient)
      last_user = User.last
      last_mail = ActionMailer::Base.deliveries.last
      expect(last_user.email).to eq(recipient)
      expect(last_mail.to).to eq([last_user.email])
      expect(last_mail.body).to include( user_confirmation_path )
      matches = /"(https?:\/\/localhost:\d+\/user\/confirmation\?confirmation_token=.*)"/.match(last_mail.body.to_s)
      expect(matches.length).to eq(2)
      matches[1]
    end

    def login(user)
      visit_root
      find('footer a.login').click
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      find('form button[type="submit"]').click
      expect(page).to have_content(user.first_name)
      expect(page).to have_content("You have successfully logged in")
      find('button.close').click
    end
    def logout(user)
      click_link "Hi, #{user.first_name}"
      click_link 'Log Out'
    end
  end

end