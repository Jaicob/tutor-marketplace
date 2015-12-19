source 'https://rubygems.org' do
  ruby '2.2.0'

  group :development, :test do
    gem 'byebug', '~> 5.0'
    gem 'spring', '~> 1.3'
    gem 'rubocop', '~> 0.32'
    gem 'rspec-rails', '~> 3.3'
    gem 'factory_girl_rails', '~> 4.5'
    gem 'capybara'
    gem 'capybara-webkit'
  end

  group :development do
    gem 'rails_layout', '~> 1.0'
    gem 'spring-commands-rspec', '~> 1.0'
  end

  group :test do
    gem 'ci_reporter', '~> 2.0'
    gem 'ci_reporter_rspec', '~> 1.0'
    gem 'database_cleaner', '~> 1.4'
    gem 'headless'
    gem 'launchy', '~> 2.4'
  end

  group :production do
    gem 'unicorn', '~> 4.9'
    gem 'unicorn-rails', '~> 2.2'
  end

  gem 'rails', '~> 4.2'
  gem 'uglifier', '~> 2.7'
  gem 'jbuilder', '~> 2.3'
  gem 'devise', '~> 3.5'
  gem 'devise_invitable', '~> 1.5'
  gem 'pg', '~> 0.18'
  gem 'figaro', '~> 1.1'
  gem 'annotate', '~> 2.6'
  gem 'friendly_id', '~> 5.1'
  gem 'carrierwave', '~> 0.10'
  gem 'rmagick', '~> 2.15'
  gem 'simple_form'
  gem 'rack-cors'
  gem 'gon'
  gem 'premailer-rails'
  gem 'nokogiri'
  gem 'sidekiq' # for info on redis, which must be running for sidekiq: http://redis.io/topics/quickstart
  gem 'sinatra', require: false
  gem 'slim'
  gem 'devise-async'
  gem 'ransack'
  gem 'fog'
  gem 'fog-aws'
  gem 'brakeman'
  gem 'faker', '~> 1.4'

  # Payments through Stripe
  gem 'stripe'
  # Service Object Managements
  gem 'interactor', "~> 3.0"

  # Front End Stuff
  gem 'bower-rails', '~> 0.9.2'
  gem 'react-rails', '~> 1.0'
  gem 'sass-rails', '~> 5.0'
  gem "foundation-rails", "~> 5.5"
  gem "foundation-icons-sass-rails", "~> 3.0"
end