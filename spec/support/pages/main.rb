module Support
  module Pages
    module Main
      def click_profile_menu
        find('.nav .dropdown-toggle').click
      end
      def open_my_profile
        click_profile_menu
        click_link 'My Profile'
      end
      def open_my_account
        click_profile_menu
        click_link 'My Account'
      end
      def stripe_connect(business)
        login(business)
        click_profile_menu
        click_link 'My Account'
        click_link 'Banking Information'
        find('#stripe-connect').click
        expect(page).to have_content('Development Mode')
        click_link 'Skip this account form'
        expect(page).to have_content('Your account has been connected to Stripe', :wait => 4)
        logout(business)
      end
    end
  end
end