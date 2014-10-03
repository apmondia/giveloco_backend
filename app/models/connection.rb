class Connection < ActiveRecord::Base
	belongs_to :trans, :class_name => "Transaction", :foreign_key => "trans_id"
	belongs_to :user, :class_name => "User", :foreign_key => "from_connection_id"
	belongs_to :user, :class_name => "User", :foreign_key => "to_connection_id"

	# Callbacks 
	after_save :check_connection_balance

	private
	# =======================================================================
	# 	Update Business' Published state based on connection balance for pledges
	# =======================================================================
	def check_connection_balance
		t = Transaction.find(self.trans_id)
		fromUser = User.find(self.from_connection_id)

		if (self.trans_type == 'pledge') && (self.connection_balance <= 0)
			fromUser.is_published = false
			fromUser.save
		end

		if (self.trans_type == 'pledge') && (self.connection_balance > 0)
			fromUser.is_published = true
			fromUser.save
		end
	end
end
