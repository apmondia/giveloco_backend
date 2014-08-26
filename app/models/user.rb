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
	after_create :set_default_user_values

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


	########################################################################
	# =>		Image uploads with Dropbox and the Paperclip gem		<= #
	########################################################################
	# if Rails.env.development?
	# 	has_attached_file 	:image, 
	# 						:styles => { :medium => "256x192#", :thumb => "100x100#" }, 
	# 						:default_url => "/images/users/default.jpg",
	# 						:path => ":rails_root/public/system/:class/:id/:style/:filename",
	# 						:url => "/system/:class/:id/:style/:basename.:extension"
	#     validates_attachment :image,
	# 		:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
	# else
	# 	has_attached_file 	:image,
	# 						:styles => { :medium => "256x192#", :thumb => "100x100#" }, 
	# 						:default_url => "/images/users/default.jpg",
	# 						:storage => :dropbox,
	# 					    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	# 					    :dropbox_options => {
	# 					    	:path => proc { |style| "prod/listings/#{id}/#{style}/#{image.original_filename}" }
	# 				    	}
	#     validates_attachment :image,
	# 		:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
	# end
	########################################################################


	# Set user profile picture for JSON
	def profile_picture_url
		# to be set with paperclip + google drive
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
		update_attribute(:deleted_at, Time.current)
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
	
end
