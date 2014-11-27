module Support
  module Pages
    module Main
      def click_profile_menu
        find('.nav .dropdown-toggle').click
      end
    end
  end
end