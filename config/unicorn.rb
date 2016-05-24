app_dir = "/home/rails/my-app"
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 5
preload_app true
timeout 40

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
    Rails.logger.info 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'

  end
  Rails.logger.info "Databse hostname and environment #{ENV['RDS_HOSTNAME']}  |  #{ENV['RAILS_ENV']}"
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end