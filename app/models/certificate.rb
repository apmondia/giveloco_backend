require 'securerandom'

class Certificate < ActiveRecord::Base
  attr_accessor :disable_charge

  validates_presence_of :serial_number
  validates_uniqueness_of :serial_number
  validates_presence_of :purchaser, :sponsorship
  validates_numericality_of :amount, :greater_than => 0

  belongs_to :purchaser, :class_name => 'User'
  belongs_to :sponsorship

  scope :for_business, -> (business) {
    joins(:sponsorship).where('sponsorships.business_id = ?', business.id)
  }
  scope :for_cause, -> (cause) {
    joins(:sponsorship).where('sponsorships.cause_id = ?', cause.id)
  }

  validate :business_is_published
  validate :business_is_activated

  before_create :copy_donation_percentage
  before_create :generate_redemption_code

  def business_is_published
    if !sponsorship.business.is_published
      errors.add(:business, "Must be published")
    end
  end

  def business_is_activated
    if !sponsorship.business.is_activated
      errors.add(:business, "Must be activated")
    end
  end

  def copy_donation_percentage
    self.donation_percentage = sponsorship.business.sponsorship_rate
  end

  def donated_amount
    "#{format("%.2f", (amount * donation_percentage / 100.0) )}"
  end

  def purchase_amount
    "#{format("%.2f", amount.to_f )}"
  end

  def donated_amount_in_cents
    (amount * donation_percentage).to_i
  end

  def generate_redemption_code
    self.redemption_code = SecureRandom.hex.first(6).upcase
  end

end
