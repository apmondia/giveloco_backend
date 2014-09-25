module V1::Helpers::ApiHelper
	# Define Strong Parameters for Rails app
	def safe_params(params)
		ActionController::Parameters.new(params)
	end
end