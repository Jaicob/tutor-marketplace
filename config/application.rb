require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

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

    # This tells Rails to include our Carrierwave uploaders for file attachments
    config.autoload_paths += %W(#{config.root}/app/uploaders)

    # Added to get rid of error messages in server log per advice here:
    # http://stackoverflow.com/questions/29417328/how-to-disable-cannot-render-console-from-on-rails
    config.web_console.whitelisted_ips = '10.0.2.2'

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
    config.assets.precompile += %w( vendor/modernizr )

    config.react.variant      = :production
    config.react.addons       = true


    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
