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
    gem 'rack-mini-profiler', require: false
    gem 'flamegraph', require: false
  end

  group :test do
    gem 'ci_reporter', '~> 2.0'
    gem 'ci_reporter_rspec', '~> 1.0'
    gem 'database_cleaner', '~> 1.4'
    gem 'headless'
    gem 'launchy', '~> 2.4'
    gem 'vcr'
    gem 'webmock'
  end

  group :staging, :production do
    gem 'unicorn', '~> 4.9'
    gem 'unicorn-rails', '~> 2.2'
  end

  gem 'annotate', '~> 2.6'
  gem 'carrierwave', '~> 0.10'
  gem 'devise', '~> 3.5'
  gem 'devise_invitable', '~> 1.5'
  gem 'devise-async'
  gem 'faker', '~> 1.4'
  gem 'figaro', '~> 1.1'
  gem 'friendly_id', '~> 5.1'
  gem 'fog-aws'
  gem 'fog'
  gem 'gon'  
  gem 'rails', '~> 4.2'
  gem 'jbuilder', '~> 2.3'
  gem 'nokogiri'
  gem 'pg', '~> 0.18'
  gem 'premailer-rails'
  gem 'ransack'
  gem 'rmagick', '~> 2.15'
  gem 'simple_form'
  gem 'sidekiq' # for info on redis, which must be running for sidekiq: http://redis.io/topics/quickstart
  gem 'sinatra', require: true
  gem 'uglifier', '~> 2.7' 
  gem 'kaminari'

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