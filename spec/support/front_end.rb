require 'net/http'
require 'uri'

module Support
  module FrontEnd
    def raise_front_end_error
      raise "The front-end server is not running.  You need to start the server using 'gulp build-test'"
    end
    def assert_front_end_up
      begin
      response = Net::HTTP.get_response URI('http://localhost:4999')
      if response.code != '200'
        raise_front_end_error
      end
      rescue
        raise_front_end_error
      end
    end
  end
end