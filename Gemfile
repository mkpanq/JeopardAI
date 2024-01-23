source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.2"

gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "tzinfo"
gem "tzinfo-data"

gem "faraday", "~> 2.9"

gem "sidekiq", "~> 7.2"
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'

gem "redis", "~> 5.0"

gem 'tailwindcss-rails', '~> 2.3'

gem 'turbo-rails', '~> 1.5'
gem 'importmap-rails', '~> 2.0', '>= 2.0.1'

group :development, :test do
  gem 'foreman', '~> 0.87.2'
  gem "debug", platforms: %i[ mri windows ]
  gem 'dotenv-rails'
end
