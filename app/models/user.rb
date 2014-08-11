class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable, 
	       :recoverable, :rememberable, :trackable, :validatable

	# Associations
	has_many :redemptions, :through => :vouchers_claimed

	has_many :vouchers_issued, :class_name => "Voucher", :foreign_key => "issued_by_id"
	has_many :vouchers_claimed, :class_name => "Voucher", :foreign_key => "claimed_by_id"

	has_many :transactions_created, :class_name => "Transaction", :foreign_key => "created_by_id"
	has_many :transactions_accepted, :class_name => "Transaction", :foreign_key => "accepted_by_id"
	
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


	class Roles < User
		ROLES = [ "admin", "individual", "business", "cause" ]
	end

	class Admin < User
	end

	class Person < User
	end

	class Business < User
	end

	class Cause < User
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
		self.save!
		self.authentication_token
	end

	private
	def generate_authentication_token
		loop do
			token = Devise.friendly_token
			break token unless User.where(authentication_token: token).first
		end
	end
	
end
