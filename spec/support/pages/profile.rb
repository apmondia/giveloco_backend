module Support
  module Pages
    module Profile
      def attach(fixture_name)
        page.attach_file 'profile-picture-upload', Rails.root.join('spec','fixtures',fixture_name)
      end
    end
  end
end