class User < ActiveRecord::Base
	has_many :transactions
	has_many :vouchers
	has_many :redemptions, :through => :vouchers

	# Include default devise modules. Others available are:
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable, 
	       :recoverable, :rememberable, :trackable, :validatable

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
