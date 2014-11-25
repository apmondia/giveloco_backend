module V1
  module Users
    class Snapshot < Grape::Entity
      expose :id, :documentation => {:type => "integer", :desc => "The numeric id of the user"}
      expose :role, :documentation => {:type => "string", :desc => "The user's type"}
      expose :company_name

      with_options(if: {:type => 'authorized'}) do
        expose :email, :documentation => {:type => "string", :desc => "The email address of the user"}
        expose :first_name, :documentation => {:type => "string", :desc => "The user's First Name"}
        expose :last_name, :documentation => {:type => "string", :desc => "The user's Last Name"}
      end

      # expose :images do
      #   expose :profile_picture do
      #     expose :original,  :documentation => {:type => "attachment", :desc => "The URL for the user's profile picture"}
      #     expose :medium,  :documentation => {:type => "attachment", :desc => "The URL for the user's profile picture"}
      #     expose :thumb,  :documentation => {:type => "attachment", :desc => "The URL for the user's profile picture"}
      #   end
      # end
    end
  end
end