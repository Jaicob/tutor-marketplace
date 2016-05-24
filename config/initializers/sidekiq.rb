redis_domain = ENV['VAGRANT_REDIS_1_PORT_6379_TCP_ADDR'] || ENV['WEBAPP_REDIS_1_PORT_6379_TCP_ADDR'] || ENV['AXON_REDIS_1_PORT_6379_TCP_ADDR'] || ENV['REDIS_PRODUCTION_ADDR'] || ENV['REDIS_PROVIDER']
redis_port   = ENV['VAGRANT_REDIS_1_PORT_6379_TCP_PORT'] || ENV['WEBAPP_REDIS_1_PORT_6379_TCP_PORT'] || ENV['AXON_REDIS_1_PORT_6379_TCP_PORT'] || ENV['REDIS_PRODUCTION_PORT']

if redis_domain && redis_port
  redis_url = "redis://#{redis_domain}:#{redis_port}"

  Sidekiq.configure_server do |config|
    config.redis = {
      namespace: "sidekiq",
      url: redis_url,
      network_timeout: 5
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      size: 1,
      namespace: "sidekiq",
      url: redis_url,
      network_timeout: 5
    }
  end
end