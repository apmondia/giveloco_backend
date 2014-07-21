source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use unicorn as the app server
gem 'unicorn'

group :default do
	# Easy file attachment management for ActiveRecord.
	gem 'paperclip', '~> 4.1'
	# Dropbox file attachment storage
	gem 'paperclip-dropbox', '>= 1.1.7'
	# Simple Rails app configuration.
	gem 'figaro'
	# Use ActiveModel has_secure_password
	gem 'bcrypt', '~> 3.1.7'
	# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
	gem 'turbolinks'
	# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
	gem 'jbuilder', '~> 2.0'
end

group :doc, :test do
	# bundle exec rake doc:rails generates the API under doc/api.
	gem 'sdoc', '~> 0.4.0'
end

group :development, :test do
	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
	gem 'spring'
	# Library for generating fake data such as names, addresses, and phone numbers. http://faker.rubyforge.org
	gem 'faker'
	gem 'debugger2'
#	gem 'rspec-rails'
#	gem 'factory_girl'
#	gem 'simplecov'
end

group :production do
	# Makes running your Rails app easier. https://github.com/heroku/rails_12factor
	gem 'rails_12factor'
end
