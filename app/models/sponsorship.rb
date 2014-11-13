class Sponsorship < ActiveRecord::Base

  MAX_FAILED_REQUESTS = 2

  enum :status => [ :pending, :accepted, :cancelled ]

  validates_presence_of :business
  validates_associated :business
  validate :no_current_pending_sponsorship
  validate :max_cancelled_requests

  belongs_to :business, :class_name => User
  belongs_to :cause, :class_name => User

  def no_current_pending_sponsorship
    if self.business.sponsorships.exists?(:status => Sponsorship.statuses[:pending], :cause_id => self.cause.id)
      errors.add(:business, "A sponsorship request has already been created for this cause.")
    end
  end

  def max_cancelled_requests
    if self.business.sponsorships.where(:status => Sponsorship.statuses[:cancelled], :cause_id => self.cause.id).count >= MAX_FAILED_REQUESTS
      errors.add(:business, "You can request sponsorship at most #{MAX_FAILED_REQUESTS} times.")
    end
  end

  def business_name
    self.business.company_name
  end

  def cause_name
    self.cause.company_name
  end

end
