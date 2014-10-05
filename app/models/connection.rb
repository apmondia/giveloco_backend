class Connection < ActiveRecord::Base
	has_many :trans, :class_name => "Transaction", :foreign_key => "connection_id"
	belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
	belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"

	# Callbacks 
	after_save :check_if_active

	private
	# =======================================================================
	# 	Update Connection's Active state based on connection_balance
	# =======================================================================
	def check_if_active
		c = Connection.find(self.id)
		if c.connection_balance > 0
			update_column :is_active, true
		else
			update_column :is_active, false
		end
	end

end
