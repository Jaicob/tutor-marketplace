app_dir = "/home/rails/my-app"
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 3
preload_app true
timeout 60

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.my-app.sock",  :backlog => 1024

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{app_dir}/tmp/pids/unicorn.pid"