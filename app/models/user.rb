class User < ActiveRecord::Base

	# Include default devise modules. Others available are:
	# :lockable, :timeoutable and
	devise :database_authenticatable, :registerable, :confirmable, 
	       :recoverable, :rememberable, :trackable, :validatable
  	devise :omniauthable, :omniauth_providers => [:stripe_connect]



	has_many :certificates, :foreign_key => 'purchaser_id', :inverse_of => :purchaser

	has_many :sponsorships, :foreign_key => 'business_id', :class_name => 'Sponsorship', :dependent => :destroy, :inverse_of => :business
	has_many :causes, -> { where :is_published => true }, :through => :sponsorships, :source => :cause
  has_many :purchased_certificates, :through => :sponsorships, :source => :certificates

	has_many :sponsors, :foreign_key => 'cause_id', :class_name => 'Sponsorship', :dependent => :destroy, :inverse_of => :cause
	has_many :businesses,  -> { where :is_published => true }, :through => :sponsors
  has_many :sponsor_certificates, :through => :sponsors, :source => :certificates

  accepts_nested_attributes_for :certificates
  ########################################################################
  # =>    Image uploads with the Paperclip gem (Amazon S3 storage)	<= #
  ########################################################################
  has_attached_file 	:profile_picture,
                     :styles => {
                         :medium => ["260x192#", :jpeg],
                         :thumb => ["100x100#", :jpeg]
                     },
                     #:convert_options => { :all => '-quality 99' },
                     :default_url => "/images/users/default.png"

  validates_attachment :profile_picture,
                       :content_type => { :content_type => ["image/jpeg", "image/png"] }
  ########################################################################

  validates :profile_picture, :dimensions => { :width => 800, :height => 800 }
  validates_presence_of :role, :email
  attr_accessor :disable_admin
	validate :cannot_set_role_to_admin, :unless => :disable_admin
  validate :agree_to_tc, :acceptance => true
  validates_presence_of :company_name, :if => 'cause? || business?'
  validates_uniqueness_of :company_name, :if => 'cause? || business?'
  validates :email, :uniqueness => true
  validate :remove_campaign_tags_from_tag

  # Taggable
  acts_as_taggable_on :tags, :campaigns

  # Callbacks
  before_save :smart_add_url_protocol
  before_create :set_authentication_token
  before_save :generate_password
  before_save :automatically_publish_business_if_profile_complete, :if => 'business?'
  before_save :automatically_publish_cause_if_profile_complete, :if => 'cause?'
  before_save :automatically_activate_cause, :if => 'cause?'
  after_save :update_sponsors_if_unpublished, :if => 'cause?'

  scope :active, -> {
    where("role != 'business' or (role = 'business' and is_activated = ? and is_published = ?)", true, true)
  }

  def update_sponsors_if_unpublished
    if self.is_published_changed? && !self.is_published
      self.businesses.each do |b|
        b.automatically_publish_business_if_profile_complete
        b.save
      end
    end
    true
  end

	def cannot_set_role_to_admin
		if self.role_changed? && self.role == :admin
			errors.add(:role, "You cannot change your role to admin.")
    end
    true
	end

	def has_stripe_connect
		!self.provider.blank? && self.provider.to_sym == :stripe_connect && !self.uid.blank?
  end

  def remove_campaign_tags_from_tag
    campaign_counts = User.tag_counts_on(:campaigns)
    campaign_counts.each do |count|
      tag_list.delete(count.name)
    end
  end

	def stripe_user_omniauth_authorize_path
    Rails.application.routes.url_helpers.user_omniauth_authorize_url(:stripe_connect,
                                                                      :'stripe_user[email]' => self.email,
                                                                      :redirect_uri => Rails.application.routes.url_helpers.user_omniauth_callback_url(:stripe_connect))
	end

	def generate_password
		if self.individual? && self.new_record? && self.password.blank?
			self.password = Devise.friendly_token.first(8)
			self.password_confirmation = self.password
			self.skip_confirmation!
    end
    true
  end

  def has_sponsorship_for_published_cause
    result = false
    self.causes.each do |c|
      if c.is_published
        result = true
      end
    end
    result
  end

  def automatically_publish_business_if_profile_complete
    if  !self.description.blank? &&
        !self.summary.blank? &&
        !self.causes.empty?
        self.is_published = true
    else
      self.is_published = false
    end
    true
  end

  def automatically_publish_cause_if_profile_complete
    if !self.description.blank? &&
        !self.summary.blank?
      self.is_published = true
    else
      self.is_published = false
    end
    true
  end

  def automatically_activate_cause
    self.is_activated = true
  end

	def admin?
		self.role == :admin
	end

	def individual?
		self.role == :individual
  end

  def business?
    self.role == :business
  end

  def cause?
    self.role == :cause
  end

	def role
		r = self.read_attribute(:role)
		if r.nil?
			nil
		else
			r.to_sym
		end
	end

	def password_required?
		super if confirmed?
	end

	def password_match?
		self.errors[:password] << "can't be blank" if password.blank?
		self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
		self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
		password == password_confirmation && !password.blank?
	end

	# =======================================================================
	# 	Model Scopes
	# =======================================================================
	def transaction_type(type)
		where("connection.trans_type = " + type, true)
	end

	def filter_by_transaction_type
		where("connection.trans_type = 'donation'", true)
	end

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
	def set_authentication_token
		self.authentication_token = generate_authentication_token
  end

  def ensure_authentication_token
    set_authentication_token
    save!
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
