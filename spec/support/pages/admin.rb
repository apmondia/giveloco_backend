module Support
  module Pages
    module Admin

      def open_sponsorships
        click_profile_menu
        click_link 'Dashboard'
        expect(page).to have_content('Sponsorships')
        click_link 'Sponsorships'
      end

    end
  end
end