class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable, 
	       :recoverable, :rememberable, :trackable, :validatable

	# Associations
	has_many :transactions_created, :class_name => "Transaction", :foreign_key => "from_user_id"
	has_many :transactions_accepted, :class_name => "Transaction", :foreign_key => "to_user_id"

	# Taggable
	acts_as_taggable

	# Callbacks
	before_save :smart_add_url_protocol
	after_create :set_default_user_values, :assign_customer_id


	########################################################################
	# =>		Image uploads with Dropbox and the Paperclip gem		<= #
	########################################################################
	if Rails.env.local?
		has_attached_file 	:profile_picture, 
							:styles => {
								:medium => ["260x192#", :jpeg], 
								:thumb => ["100x100#", :jpeg] 
							},
							:use_timestamp => false,
							:default_url => "",
							:path => "/public/system/:attachment/:class/:id/:style/:filename",
							:url => "/system/:attachment/:class/:id/:style/:filename"
	    validates_attachment :profile_picture,
			:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
	elsif Rails.env.development?
		has_attached_file 	:profile_picture, 
							:styles => {
								:medium => ["260x192#", :jpeg], 
								:thumb => ["100x100#", :jpeg] 
							},
							:default_url => ""
	    validates_attachment :profile_picture,
			:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
	else
		has_attached_file 	:profile_picture,
							:styles => {
								:medium => ["260x192#", :jpeg], 
								:thumb => ["100x100#", :jpeg] 
							},
							:default_url => ""
	    validates_attachment :profile_picture,
			:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
	end
	########################################################################

	# User Roles
	class Roles < User
		ROLES = [ :admin, :individual, :business, :cause ]
	end

	class Admin < User
	end

	class Person < User
	end

	class Business < User
	end

	class Cause < User
	end

	# Profile picture styles for JSON rendering
	def original
		profile_picture.url(:original)
	end

	def medium
		profile_picture.url(:medium)
	end

	def thumb
		profile_picture.url(:thumb)
	end

	# Get user's full name (if individual) or company name (if business or cause)
	def self.get_user_name(uid)
		@user = User.find(uid)
		if @user.role == 'individual'
			@user.first_name + ' ' + @user.last_name
		else
			@user.company_name
		end
	end

	# Get user type
	def self.get_user_role(uid)
		@user = self.find(uid)
		@user.role
	end

	# Soft Delete user when "destroy" method is called instead of a deleting entire database field
	def soft_delete
		u = User.find(self.id)
		result = Braintree::Customer.delete(u.customer_id)
		if result.success?
			puts "customer successfully deleted"
		else
			raise "this should never happen"
		end
		u.deleted_at = Time.current
		u.save
	end

	# Ensure deleted users cannot sign in
	def active_for_authentication?
		super && !deleted_at
	end

	# Used for user authentication
	def ensure_authentication_token
		self.authentication_token = generate_authentication_token
		self.save
		self.authentication_token
	end


	private

	def generate_authentication_token
		loop do
			token = Devise.friendly_token
			break token unless User.where(authentication_token: token).first
		end
	end

	def set_default_user_values
		u = User.find(self.id)
		u.total_funds_raised = 0.00
		u.balance = 0.00
		u.save
	end

	# Generate customer ID for Braintree (stored in the database)
	def generate_random_number
		SecureRandom.random_number(100000000)
	end

	def assign_customer_id
		@uniqueId = generate_random_number

		User.all.each do |u|
			if u.customer_id == @uniqueId
				puts "Found matching Customer ID! Generating new one."
				@uniqueId = generate_random_number
			end
		end

		c = User.find(self.id)
		c.customer_id = "stripe_id_" + @uniqueId.to_s
		c.save
	end

	def create_new_stripe_customer(uid)
		u = User.find(uid)
		# result = Braintree::Customer.create(
		#   :id => u.customer_id,
		#   :first_name => u.first_name,
		#   :last_name => u.last_name,
		#   :email => u.email
		# )
	end


	protected
	# Add http:// protocol to website if it is absent
	def smart_add_url_protocol
		if self.website && !url_protocol_present?
			self.website = "http://#{self.website}"
		end
	end

	def url_protocol_present?
		self.website[/\Ahttp:\/\//] || self.website[/\Ahttps:\/\//]
	end
	
end
