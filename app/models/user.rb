class User < ActiveRecord::Base

  validates_presence_of :role

	# Include default devise modules. Others available are:
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable, 
	       :recoverable, :rememberable, :trackable, :validatable

  	has_many :certificates, :foreign_key => 'purchaser_id'

	has_many :sponsorships, :foreign_key => 'business_id', :class_name => 'Sponsorship', :dependent => :destroy
	has_many :causes, :through => :sponsorships, :source => :cause

	has_many :sponsors, :foreign_key => 'cause_id', :class_name => 'Sponsorship', :dependent => :destroy
	has_many :businesses, :through => :sponsors

	def admin?
		self.role == :admin
	end

	def role
		r = self.read_attribute(:role)
		if r.nil?
			nil
		else
			r.to_sym
		end
	end

	# Taggable
	acts_as_taggable

	# Callbacks
	before_save :smart_add_url_protocol

	# =======================================================================
	# 	Model Scopes
	# =======================================================================
	def transaction_type(type)
		where("connection.trans_type = " + type, true)
	end

	def filter_by_transaction_type
		where("connection.trans_type = 'donation'", true)
	end


	########################################################################
	# =>    Image uploads with the Paperclip gem (Amazon S3 storage)	<= #
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

	# =======================================================================
	# 	User Roles (to be completed later)
	# =======================================================================
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


	# =======================================================================
	# 	Profile picture styles for JSON rendering
	# =======================================================================
	def original
		profile_picture.url(:original)
	end

	def medium
		profile_picture.url(:medium)
	end

	def thumb
		profile_picture.url(:thumb)
	end


	# =======================================================================
	# 	Get user's full name (if individual) or company name (if business or cause)
	# =======================================================================
	def self.get_user_name(uid)
		@user = User.find(uid)
		if @user.role == 'individual'
			@user.first_name + ' ' + @user.last_name
		else
			@user.company_name
		end
	end

	# =======================================================================
	# 	Get user type
	# =======================================================================
	def self.get_user_role(uid)
		@user = self.find(uid)
		@user.role
	end


	# =======================================================================
	# 	Soft Delete Users
	# =======================================================================
	# Soft Delete user when "destroy" method is called instead of deleting entire database field
	def soft_delete
		u = User.find(self.id)
		u.deleted_at = Time.current
		u.save
	end

	# Ensure deleted users cannot sign in
	def active_for_authentication?
		super && !deleted_at
	end


	# =======================================================================
	# 	User Authentication
	# =======================================================================
	# Ensure the user has an auth token (used for user authentication)
	def ensure_authentication_token
		self.authentication_token = generate_authentication_token
		self.save
		self.authentication_token
	end


	private
	# =======================================================================
	# 	Generate Authentication Token
	# =======================================================================
	def generate_authentication_token
		loop do
			token = Devise.friendly_token
			break token unless User.where(authentication_token: token).first
		end
	end


	protected
	# =======================================================================
	# 	Add http:// protocol to website if it is absent
	# =======================================================================
	def smart_add_url_protocol
		if self.website && !url_protocol_present?
			self.website = "http://#{self.website}"
		end
	end

	def url_protocol_present?
		self.website[/\Ahttp:\/\//] || self.website[/\Ahttps:\/\//]
	end
	
end
