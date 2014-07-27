module API
	class Root < Grape::API
		prefix ''
		mount V1::Base
	end
end