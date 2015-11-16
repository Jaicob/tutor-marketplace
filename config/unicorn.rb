app_dir = "/home/rails/my-app"
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 3
preload_app true
timeout 20

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.my-app.sock",  :backlog => 1024

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{app_dir}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection

  Sidekiq.configure_client do |config|
    config.redis = { size: 1 }
  end
end