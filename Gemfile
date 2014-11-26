source 'https://code.stripe.com'
source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use unicorn as the app server
gem 'unicorn'
# Devise user authentication
gem 'devise'
gem 'omniauth-stripe-connect'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'cancan'

group :default do
	# Required dependencies
	gem 'coffee-rails', '~> 4.0.0'
	gem 'jquery-rails'
	# Easy file attachment management for ActiveRecord.
	gem 'paperclip', '~> 4.2'
	# Amazon S3 for file storage
	gem 'aws-sdk'
	# Tagging model for anything
	gem 'acts-as-taggable-on'
	# Figaro - Simple Rails app configuration.
	gem 'figaro'
	# Global - Provides accessor methods for your configuration data
	gem 'global'
	# Seedbank - Generate Database SEED data for multiple environments
	gem 'seedbank'
	# Library for generating fake data such as names, addresses, and phone numbers. http://faker.rubyforge.org
	gem 'faker'
	# Stripe Payment Processor
	gem 'stripe'

	### API Gems ###
	gem 'grape', '~> 0.9.0'
	gem 'grape-entity'
	# Rack Middleware for handling Cross-Origin Resource Sharing (CORS)
	gem 'rack-cors', :require => 'rack/cors'
	# API Documentation Library
#	gem 'apipie-rails'
end

group :doc, :test do
	# bundle exec rake doc:rails generates the API under doc/api.
	gem 'sdoc', '~> 0.4.0'
end

group :development, :test do
	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
	gem 'spring'
	# debugger2 is a fork of debugger for Ruby 2.0
	#gem 'debugger2'
	# Better, more useful error handling
	gem 'better_errors'
	# Acceptance test framework
	gem 'capybara'
	# Tool for writing automated tests for websites
	gem 'selenium-webdriver'
	# A library for setting up Ruby objects as test data.
	gem 'factory_girl_rails'
	# Rails Unit Testing RSPEC
	gem 'rspec-rails'
  	gem 'json_spec'
	# Strategies for cleaning databases in Ruby.
	gem 'database_cleaner'

  	# gem 'sqlite3'

end

group :production do
	# Makes running your Rails app easier. https://github.com/heroku/rails_12factor
	gem 'rails_12factor'
end