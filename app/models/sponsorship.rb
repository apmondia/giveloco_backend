class Sponsorship < ActiveRecord::Base

  MAX_FAILED_REQUESTS = 2
  MAX_SPONSORED_CAUSES = 3

  enum :status => [ :pending, :accepted, :cancelled ]

  validates_presence_of :business
  validates_associated :business
  validate :is_business
  validate :no_current_pending_sponsorship
  validate :max_cancelled_requests
  validate :max_sponsored_causes

  belongs_to :business, :class_name => User
  belongs_to :cause, :class_name => User

  before_create :default_status

  after_update :check_status

  has_many :certificates

  def check_status
    if self.status_changed?
      if self.cancelled?
        TalifloMailer.sponsorship_cancelled_admin_notification(self).deliver
      elsif self.accepted?
        TalifloMailer.sponsorship_accepted_admin_notification(self).deliver
      end
    end
  end

  def is_business
    errors.add(:business, "Must be a business") unless self.business.role == :business
  end

  def no_current_pending_sponsorship
    if self.business.sponsorships.where.not(:id => self.id).exists?(:status => Sponsorship.statuses[:pending], :cause_id => self.cause.id)
      errors.add(:business, "A sponsorship request has already been created for this cause.")
    end
  end

  def max_sponsored_causes
    if (self.business.sponsorships + [self]).uniq.size > MAX_SPONSORED_CAUSES
      errors.add(:business, "A business can sponsor at most #{MAX_SPONSORED_CAUSES} causes.")
    end
  end

  def max_cancelled_requests
    if self.business.sponsorships.where.not(:id => self.id).where(:status => Sponsorship.statuses[:cancelled], :cause_id => self.cause.id).count >= MAX_FAILED_REQUESTS
      errors.add(:business, "You can request sponsorship at most #{MAX_FAILED_REQUESTS} times.")
    end
  end

  def business_name
    self.business.company_name
  end

  def cause_name
    self.cause.company_name
  end

  private

  def default_status
    self.status ||= 0
  end

end
