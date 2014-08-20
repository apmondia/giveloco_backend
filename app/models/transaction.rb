class Transaction < ActiveRecord::Base
	include ActiveModel::Validations
	belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
	belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"

	# Callbacks 
	before_validation :create_id, :if => 'self.new_record?'
	# validates :trans_id, :uniqueness => true
	validates :amount, :presence => true
	before_save :update_status, :transaction_possible?
	after_save :variables_init, :update_supporters, :update_user_balance
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

	# Generate unique ID for each new transaction
	def create_id
		@uniqueId = Time.now.to_i + (1000 + Random.rand(8999))
		# Ensure uniqueness
		Transaction.all.each do |t|
			if t.trans_id == @uniqueId
				puts "Found matching Transaction ID! Generating new one."
				@uniqueId = Time.now.to_i + (1000 + Random.rand(8999))
			end
		end
	end

	# Set unique ID for each new transaction
	def set_trans_id
		t = Transaction.find(self.id)
		t.trans_id = @uniqueId
		t.save
	end

	# Update Status Columns
	def update_status
		if self.status == 'cancelled'
			self.cancelled_at = Time.now
		end

		if self.status == 'complete'
			self.completed_at = Time.now
		end
	end	

	# Initialize variables for transaction functions
	def variables_init
		@transaction = Transaction.find(self.id)
		@type = @transaction.trans_type
		@status = @transaction.status
		@from_user_id = @transaction.from_user_id
		@to_user_id = @transaction.to_user_id
	end

	# Update Business' list of supported_causes and Cause's list of supporters (businesses)
	def update_supporters
		if @type == 'pledge' && @status == 'complete' then
			# Update businesses with IDs of supported causes
			b = User.find(@from_user_id)
			b.supported_causes += Array(@to_user_id)
			b.save
			# Update Causes with IDs of supporting businesses 
			c = User.find(@to_user_id)
			c.supporters += Array(@from_user_id)
			c.save
		end
	end

	def update_user_balance
		if @type == 'donation' && @status == 'complete' then
			# Increase Individual's (donor) credits balance
			u = User.find(@from_user_id)
			u.balance += @transaction.amount
			u.save

			# Decrease Cause's credits balance and add to its total_funds_raised
			c = User.find(@to_user_id)
			c.balance -= @transaction.amount
			c.total_funds_raised += @transaction.amount
			c.save
		end

		if @type == 'pledge' && @status == 'complete' then
			# Decrease Business' credits balance
			b = User.find(@from_user_id)
			b.balance -= @transaction.amount
			b.save

			# Increase Cause's credits balance
			c = User.find(@to_user_id)
			c.balance += @transaction.amount
			c.save
		end

		if @type == 'redemption' && @status == 'complete' then
			# Decrease Individual's credits balance
			u = User.find(@from_user_id)
			u.balance -= @transaction.amount
			u.save

			# Increase business' credits balance
			b = User.find(@to_user_id)
			b.balance += @transaction.amount
			b.save
		end
	end

	def transaction_possible?
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