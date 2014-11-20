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

  validate :charge_stripe_token, :unless => :disable_charge

  def charge_stripe_token
    StripeCharge.call({
                          :amount => self.amount,
                          :card => self.stripeToken,
                          :currency => 'cdn'
                      })
  end

end
