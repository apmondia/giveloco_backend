module V1::Defaults
  extend ActiveSupport::Concern

  included do
    # common Grape settings
    version 'v1'
    format :json
    formatter :json, PrettyJSON

    # global handler for simple not found case
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end

    # global exception handler, used for error notifications
    rescue_from :all do |e|
      if Rails.env.development? || Rails.env.local? || Rails.env.test?
        raise e
      else
        error_response(message: "Internal server error", status: 500)
      end
    end

    # HTTP headers
    before do
      header "X-Robots-Tag", "noindex"
      header 'Access-Control-Allow-Origin', '*'
    end

    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: :any
      end
    end

  end
end

# Custom formatting to display "pretty" JSON data
module PrettyJSON
  def self.call(object, env)
    if (object && env['api.format'] == :json)
      JSON.pretty_generate(JSON.parse(object.to_json))
    end
  end
end