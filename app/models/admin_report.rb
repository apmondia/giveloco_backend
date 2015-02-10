class AdminReport < ActiveRecord::Base

  def readonly?
    true
  end

end