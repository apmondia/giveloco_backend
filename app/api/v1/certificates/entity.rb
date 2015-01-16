class V1::Certificates::Entity < Grape::Entity

  expose :id, :documentation => {:type => "integer", :desc => "The database ID of the connection."}
  expose :sponsorship, :using => V1::Sponsorships::Snapshot
  expose :donation_percentage
  expose :amount
  expose :recipient
  expose :purchaser, :using => V1::Users::Snapshot
  expose :serial_number

  expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was started."}
  expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the transaction was last updated."}

end
