class Transaction < ActiveRecord::Base
	include ActiveModel::Validations
	belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
	belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"

	# Callbacks 
	before_validation :create_id, :if => 'self.new_record?'
	validates :amount, :presence => true
	before_save :set_running_balance, :set_user_names_and_roles, :set_trans_type, :update_status
	after_save :update_supporters
	after_create :set_trans_id

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
		@uniqueId = Time.now.to_i + (10000 + Random.rand(89999))
		# Ensure uniqueness
		Transaction.all.each do |t|
			if t.trans_id == @uniqueId
				puts "Found matching Transaction ID! Generating new one."
				@uniqueId = Time.now.to_i + (10000 + Random.rand(89999))
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
	# 	Update Business' list of supported_causes and Cause's list of supporters (businesses)
	# =======================================================================
	def update_supporters
		if self.trans_type == 'pledge' && self.status == 'complete' then
			# Update businesses with IDs of supported causes
			b = User.find(self.from_user_id)
			if b.supported_causes.include? (self.to_user_id)
				puts "Cause ID #{self.to_user_id} already found in Business' list of supported_causes"
			else
				b.supported_causes += Array(self.to_user_id)
			end
			b.save

			# Update Causes with IDs of supporting businesses 
			c = User.find(self.to_user_id)
			if c.supporters.include? (self.from_user_id)
				puts "Business ID #{self.from_user_id} already found in Cause's list of supporters"
			else
				c.supporters += Array(self.from_user_id)
			end
			c.save
		end
	end


	# =======================================================================
	# 	Set Running Balance 
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
	
end