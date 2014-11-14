class Certificate < ActiveRecord::Base
  validates_presence_of :purchaser, :sponsorship
  belongs_to :purchaser, :class_name => 'User'
  belongs_to :sponsorship
end
