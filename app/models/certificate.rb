class Certificate < ActiveRecord::Base
  belongs_to :purchaser, :class_name => 'User'
  belongs_to :sponsorship
end
