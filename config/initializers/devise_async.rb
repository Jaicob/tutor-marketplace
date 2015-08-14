##
# Configuration for Devise emails to be sent asyncronously with Sidekiq
#
# docs: https://github.com/mhfs/devise-async
#

Devise::Async.setup do |config|
  config.enabled = true
  config.backend = :sidekiq
  config.queue   = :mailer
end