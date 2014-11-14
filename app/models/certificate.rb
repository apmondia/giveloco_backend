class Certificate < ActiveRecord::Base
  validates_presence_of :purchaser, :sponsorship
  belongs_to :purchaser, :class_name => 'User'
  belongs_to :sponsorship
  scope :for_business, -> (business) {
    joins(:sponsorship).where('sponsorships.business_id = ?', business.id)
  }
  scope :for_cause, -> (cause) {
    joins(:sponsorship).where('sponsorships.cause_id = ?', cause.id)
  }
end
