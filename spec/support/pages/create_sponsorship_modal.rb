module Support
  module Pages
    module CreateSponsorshipModal
      def click_typeahead_business
        find("form#adminSponsorshipForm .select-business ul li a").click
      end
      def click_typeahead_cause
        find("form#adminSponsorshipForm .select-cause ul li a").click
      end
    end
  end
end