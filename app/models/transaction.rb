class Transaction < ActiveRecord::Base
	include ActiveModel::Validations
	belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
	belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"
	has_one :connection, :class_name => "Connection", :foreign_key => "trans_id"

	# Callbacks 
	before_validation :create_id, :if => 'self.new_record?'
	validates :amount, :presence => true
	before_save :set_running_balance, :set_user_names_and_roles, :set_trans_type, :update_status
	after_create :set_trans_id, :create_user_connection

	# Transaction Types
	class Type < Transaction
		# WARNING: Do not change the order of the array. It may potentially affect the functionality of the app adversely.
		TYPE = [ :pledge, :donation, :redemption ]
	end

	# Transaction Statuses
	class Status < Transaction
		STATUS = [ :pending, :cancelled, :complete ]
	end


	private
	# =======================================================================
	# 	Generate and set unique ID for each new transaction
	# =======================================================================
	def create_id
		@uniqueId = Time.now.to_i + SecureRandom.random_number(1000000)
		# Ensure uniqueness
		Transaction.all.each do |t|
			if t.trans_id == @uniqueId
				puts "Found matching Transaction ID! Generating new one."
				@uniqueId = Time.now.to_i + SecureRandom.random_number(1000000)
			end
		end
	end

	# Set unique ID for each new transaction
	def set_trans_id
		t = Transaction.find(self.id)
		t.trans_id = @uniqueId
		t.save
	end


	# =======================================================================
	# 	Set "to" and "from" user names based on supplied user IDs
	# =======================================================================
	def set_user_names_and_roles
		self.from_name = User.get_user_name(self.from_user_id)
		self.to_name = User.get_user_name(self.to_user_id)

		self.from_user_role = User.get_user_role(self.from_user_id)
		self.to_user_role = User.get_user_role(self.to_user_id)
	end


	# =======================================================================
	# 	Update Transaction Status
	# =======================================================================
	def update_status
		if self.status == 'cancelled'
			self.cancelled_at = Time.now
		end

		if self.status == 'complete'
			self.completed_at = Time.now
		end
	end


	# =======================================================================
	# 	Update Transaction Type
	# =======================================================================
	def set_trans_type
		from = User.find(self.from_user_id)
		to = User.find(self.to_user_id)

		if from.role == 'individual' && to.role == 'cause'
			self.trans_type = 'donation'
		end

		if from.role == 'individual' && to.role == 'business'
			self.trans_type = 'redemption'
		end

		if from.role == 'business' && to.role == 'cause'
			self.trans_type = 'pledge'
		end
	end


	# =======================================================================
	# 	Set Running Balances
	# =======================================================================
	def set_running_balance
		fromUser = User.find(self.from_user_id)
		toUser = User.find(self.to_user_id)
		self.from_user_balance = fromUser.balance
		self.to_user_balance = toUser.balance


		#    Donations    #
		###################
		if self.trans_type == 'donation' && self.status == 'complete'
			# Donor's balance
			self.from_user_balance += self.amount
			fromUser.balance = self.from_user_balance
			fromUser.save

			# Cause's balance
			self.to_user_balance -= self.amount
			toUser.balance = self.to_user_balance
			toUser.total_funds_raised += self.amount
			toUser.save
		end


		#     Pledges     # Transaction status must be complete before any balances are updated
		###################
		if self.trans_type == 'pledge' && self.status == 'complete'
			# Business' balance
			self.from_user_balance -= self.amount
			fromUser.balance = self.from_user_balance
			fromUser.save

			# Cause's balance
			self.to_user_balance += self.amount
			toUser.balance = self.to_user_balance
			toUser.save
		end

		
		#   Redemptions   #
		###################
		if self.trans_type == 'redemption' && self.status == 'pending'
			# Customer - Transaction value is removed from the customer's balance (debit)
			self.from_user_balance -= self.amount
			fromUser.balance = self.from_user_balance
			fromUser.save
		end

		if self.trans_type == 'redemption' && self.status == 'complete'
			# Business - Transaction value is added to the business' balance (credit)
			self.to_user_balance += self.amount
			toUser.balance = self.to_user_balance
			toUser.save
		end

		if self.trans_type == 'redemption' && self.status == 'cancelled'
			# Customer - Transaction value is added back to the customer's balance (credit)
			self.from_user_balance += self.amount
			fromUser.balance = self.from_user_balance
			fromUser.save
		end

	end


	# =======================================================================
	# 	Check if transaction is even possible based on available credits (this may need to be done in the controller)
	# =======================================================================
	def is_possible?
		fromUser = User.find(self.from_user_id)
		toUser = User.find(self.to_user_id)

		# Check if individual has credits to redeem
		if self.trans_type == 'redemption' && fromUser.balance < 20
			# record.errors[:base] << "Insufficient credits"
			puts "Insufficient credits"
		end

		# Check if cause has credits to sell
		if self.trans_type == 'redemption' && toUser.balance < 20
			# record.errors[:base] << "Insufficient inventory"
			puts "Insufficient inventory"
		end
	end


	# =======================================================================
	# 	Create User Connections when Transaction is created
	# =======================================================================
	def create_user_connection
		t = Transaction.find(self.id)
		c = Connection.where({:from_connection_id => t.from_user_id, :to_connection_id => t.to_user_id})
		# If a connection already exists, update it, otherwise create a new one.
		if c.exists?
			if t.trans_type == "pledge"
				c.each do |p|
					p.connection_balance = get_total_pledge_amount(t.id)
					puts p.connection_balance
					p.save
				end
			end
		else
			if t.status == "complete"
				newC = Connection.new(
					:trans_id => t.id,
					:trans_type => t.trans_type,
					:from_connection_id => t.from_user_id,
					:to_connection_id => t.to_user_id,
					:connection_balance => t.amount
				)
				newC.save
			end
		end

	end

	def get_total_pledge_amount(tid)
		t = Transaction.find(tid)
		# Find all completed pledges by this user
		pledges = Transaction.where({:from_user_id => t.from_user_id, :to_user_id => t.to_user_id, :status => "complete"})
		# Map the pledge amounts to an array
		pledgeAmounts = pledges.map{|p| p.amount}
		# Add all of the pledge amounts together to form a single value
		pledgeSum = pledgeAmounts.inject(:+)
		return pledgeSum
	end

	
end