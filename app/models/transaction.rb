class Transaction < ActiveRecord::Base
	belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
	belongs_to :accepted_by, :class_name => "User", :foreign_key => "accepted_by_id"

	class Type < Transaction
		TYPE = [ "pledge", "donation" ]
	end

	class Status < Transaction
		STATUS = [ "cancelled", "confirmed", "pending" ]
	end
end
