module API
	class Root < Grape::API
		prefix '' # Appends to base URL ex: /api

		helpers V1::Helpers::ApiHelper
		helpers V1::Helpers::TransactionsHelper
		helpers V1::Helpers::UsersHelper
		
		mount V1::Base
		# mount V2::Base
		# etc.
	end

	Base = Rack::Builder.new do
		use V1::Logger
		run API::Root
	end
end