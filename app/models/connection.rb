class Connection < ActiveRecord::Base
	belongs_to :trans, :class_name => "Transaction", :foreign_key => "trans_id"
	belongs_to :user, :class_name => "User", :foreign_key => "from_connection_id"
	belongs_to :user, :class_name => "User", :foreign_key => "to_connection_id"

	private
	# =======================================================================
	# 	Method Definition
	# =======================================================================
	def method_name
		
	end
end
