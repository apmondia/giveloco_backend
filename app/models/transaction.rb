class Transaction < ActiveRecord::Base
	belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
	belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"

	before_validation :create_id, :if => 'self.new_record?'
	validates :trans_id, :uniqueness => true
	validates :amount, :presence => true

	# before_save :update_status

	class Type < Transaction
		# WARNING: Do not change the order of the array. It could adversely affect the functionality of the app.
		TYPE = [ :pledge, :donation, :redemption ]
	end

	class Status < Transaction
		STATUS = [ :pending, :cancelled, :complete ]
	end

	# Status Functions
	def self.update_status(id)
		@transaction = self.find(id)
		if @transaction.status == :cancelled then
		  @transaction.update(:cancelled_at => Time.now)
		end

		if @transaction.status == :complete then
			self.update(:completed_at => Time.now)
			self.update(:is_complete => true)
		end
	end
			
	def pending
		self.update(:status, :pending)
	end

	def cancelled
		self.update(:status, :cancelled)
		self.cancelled_at = Time.now
	end

	def completed
		self.update(:status, :complete)
		self.update(:completed_at, Time.now)
		self.update(:is_complete, true)
	end

	# Generate unique ID for each transaction
	def create_id
		Time.now.to_i + (1000 + Random.rand(8999))
	end
	
end
