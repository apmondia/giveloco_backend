module V1
  module Sponsorships
    class Entities < Grape::Entity

      expose :id, :documentation => {:type => "integer", :desc => "The database ID of the connection."}
      expose :business_id, :documentation => {:type => "integer", :desc => "The ID of the user who created the connection."}
      expose :cause_id, :documentation => {:type => "integer", :desc => "The ID of the user who accepted the connection."}
      expose :status

      expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was started."}
      expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was last updated."}

      class SnapShot < Grape::Entity
        expose :id
        expose :business_id
        expose :cause_id
        expose :status
      end
    end
  end
end