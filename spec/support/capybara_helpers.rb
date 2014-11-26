module Support
  module CapybaraHelpers
    def set_wait_time_to(wait_time)
      old_wait_time  = Capybara.default_wait_time
      Capybara.default_wait_time = wait_time
      old_wait_time
    end
  end
end