class BusinessReport < ActiveRecord::Base

  belongs_to :business, :class_name => 'User', :foreign_key => :id, :inverse_of => :report

  def readonly?
    true
  end

end