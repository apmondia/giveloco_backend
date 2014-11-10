class Sponsorship < ActiveRecord::Base
  validates_presence_of :business
  validates_associated :business
  belongs_to :business, :class_name => User
  belongs_to :cause, :class_name => User

  def business_name
    self.business.company_name
  end

  def cause_name
    self.cause.company_name
  end

end
