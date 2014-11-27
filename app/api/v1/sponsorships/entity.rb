module V1
  module Sponsorships
    class Entity < Grape::Entity

      expose :id, :documentation => {:type => "integer", :desc => "The database ID of the connection."}
      expose :business, :using => V1::Users::Snapshot, :documentation => {:type => "User SnapShot", :desc => "The ID of the user who created the connection."}
      expose :cause,    :using => V1::Users::Snapshot, :documentation => {:type => "User SnapShot", :desc => "The ID of the user who accepted the connection."}
      expose :status, :documentation => { :type => 'integer', :desc => '0 - pending, 1 - accepted, 2 - cancelled' }
      expose :resolved_at, :documentation => { :type => 'datetime', :desc => "The date and time at which the cause accepted or cancelled the sponsorship" }
      expose :donation_percentage

      expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was started."}
      expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was last updated."}

    end

  end
end