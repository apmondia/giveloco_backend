Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  config.serve_static_assets = true

  # Show full error business_reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_controller.asset_host = "localhost:3000"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Required for Devise mailer
  # config.action_mailer.default_url_options = { host: ENV["API_BASE_URL"] }

  config.action_mailer.default_url_options = {
      :host => 'localhost'
  }

  # Raise an exception if there is an error when sending an email
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.asset_host = "http://#{config.action_controller.asset_host}"

  # Email configuration settings
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              secrets.email_server || ENV["EMAIL_SERVER"],
    port:                 587,
    user_name:            secrets.email_username || ENV["EMAIL_USERNAME"],
    password:             secrets.email_password || ENV["EMAIL_PASSWORD"],
    authentication:       'plain',
    enable_starttls_auto: true
  }

  # Paperclip Amazon S3 settings
  config.paperclip_defaults = {
      :storage => :s3,
      :url => ':s3_domain_url',
      :path => ':class/:attachment/:id_partition/:style/:filename',
      :s3_credentials => {
          :bucket => secrets.s3_bucket_name || ENV['S3_BUCKET_NAME'],
          :access_key_id => secrets.aws_access_key_id || ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => secrets.aws_secret_key || ENV['AWS_SECRET_KEY']
      }
  }

  Rails.application.routes.default_url_options[:host] = "localhost:3000"

  config.front_end_base_url = 'http://localhost:5000'
  config.community_email = 'community@giveloco.com'

end
