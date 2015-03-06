module Support
  module Pages
    module Admin

      def open_businesses
        click_profile_menu
        click_link 'Dashboard'
        within '.dashboard-main' do
          expect(page).to have_content("Businesses")
          click_link 'Businesses'
        end
      end

      def open_sponsorships
        click_profile_menu
        click_link 'Dashboard'
        within '.dashboard-main' do
          expect(page).to have_content('Sponsorships')
          click_link 'Sponsorships'
        end
      end

      def open_tool_menu
        find(".user-actions a.dropdown-toggle").click
      end

    end
  end
end