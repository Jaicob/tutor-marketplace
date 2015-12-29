if Rails.env == 'development'
  require 'rack-mini-profiler'
  require 'flamegraph'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end