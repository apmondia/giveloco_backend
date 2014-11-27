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
  validate :validate_charge, :unless => :disable_charge

  def business_has_access_code
    if !sponsorship.business.access_code
      errors.add(:business, "Must have connected their banking details")
    end
  end

  def validate_charge

    self.donation_percentage = sponsorship.donation_percentage

    cause_fee = amount * donation_percentage #total donation in cents
    taliflo_fee = 100 # ?????
    total_fee = cause_fee + taliflo_fee

    StripeCharge.call(
                      :amount => (amount * 100),
                      :card => stripeToken,
                      :application_fee => total_fee,
                      :access_token => sponsorship.business.access_code
                      )

  end

end
