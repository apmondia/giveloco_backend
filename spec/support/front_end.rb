require 'net/http'
require 'uri'

module Support
  module FrontEnd
    def assert_front_end_up
      response = Net::HTTP.get_response URI('http://localhost:4999')
      if response.code != '200'
        raise "The front-end server is not running.  You need to start the server using 'grunt build-test'"
      end
    end
  end
end