class Transaction < ActiveRecord::Base
	belongs_to :user

	class Type < Transaction
		TYPE = [ "pledge", "donation" ]
	end

	class Status < Transaction
		STATUS = [ "cancelled", "confirmed", "pending" ]
	end
end
