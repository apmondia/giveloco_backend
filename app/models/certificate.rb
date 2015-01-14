require 'securerandom'

class Certificate < ActiveRecord::Base
  attr_accessor :disable_charge

  validates_presence_of :purchaser, :sponsorship
  validates_numericality_of :amount, :greater_than => 0
  belongs_to :purchaser, :class_name => 'User'
  belongs_to :sponsorship
  validates_presence_of :stripeToken, :on => :create
  attr_accessor :stripeToken
  scope :for_business, -> (business) {
    joins(:sponsorship).where('sponsorships.business_id = ?', business.id)
  }
  scope :for_cause, -> (cause) {
    joins(:sponsorship).where('sponsorships.cause_id = ?', cause.id)
  }

  validate :business_has_access_code

  before_create :copy_donation_percentage
  before_create :execute_charge, :unless => :disable_charge
  before_create :send_certificate, :unless => :disable_charge
  before_create :generate_redemption_code

  def business_has_access_code
    if !sponsorship.business.access_code
      errors.add(:business, "Must have connected their banking details")
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

  def execute_charge
    StripeCharge.call(
                      :amount => (amount * 100).to_i,
                      :card => stripeToken,
                      :application_fee => donated_amount_in_cents,
                      :description => "Gift Certificate for #{sponsorship.business.company_name}",
                      :access_token => sponsorship.business.access_code
                      )
  end

  def send_certificate
    TalifloMailer.certificate_purchase(self).deliver
  end

  def generate_redemption_code
    self.redemption_code = SecureRandom.hex.first(6).upcase
  end

end
