require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'


Bundler.require(:default, Rails.env)

module WebApp
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    # Set Active Job adpater to Sidekiq
    config.active_job.queue_adapter = :sidekiq

    # This tells Rails to look for the secret key in application.yml through Figaro rather than in the standard secrets.yml
    config.secret_key_base = Figaro.env.secret_key_base

    # This tells Rails to include our Carrierwave uploaders for file attachments
    config.autoload_paths += %W(#{config.root}/app/uploaders)
    config.autoload_paths += Dir["#{Rails.root}/app/services/**"]
    config.autoload_paths += Dir["#{Rails.root}/app/payments/**"]
    config.autoload_paths += Dir["#{Rails.root}/app/workers/**"]

    # Auto-load API and its subdirectories
    config.paths.add 'app/api', glob: '**/*.rb'
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]

    # From http://funonrails.com/2014/03/building-restful-api-using-grape-in-rails/
    # config.paths.add "app/api", glob: "**/*.rb"
    # config.autoload_paths += Dir["#{Rails.root}/app/api/*"]

    # Added to get rid of error messages in server log per advice here:
    # http://stackoverflow.com/questions/29417328/how-to-disable-cannot-render-console-from-on-rails
    # config.web_console.whitelisted_ips = '10.0.2.2'
    # config.web_console.whitelisted_ips = '192.168.59.3'

    # Added because changes were not loading automaticaly, I had to restart the server a bunch, this is supposed to fix that
    config.reload_classes_only_on_change = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # For Foundation 5
    config.assets.precompile += %w( vendor/modernizr)

    # For email stylesheets
    config.assets.precompile += %w( emails )

    # React
    config.react.variant      = :production
    config.react.addons       = true

    # Delegates front-end dependency management to Bower
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # React
    # config.react.jsx_transform_options = {
    #   blacklist: ['spec.functionName', 'validation.react'], # default options
    #   optional: ["transformerName"],  # pass extra babel options
    #   whitelist: ["useStrict"] # even more options
    # }

  end
end
