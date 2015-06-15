app_dir = File.expand_path("../..", __FILE__)
shared_dir = "/web-app/shared"
working_directory app_dir
puts " APP DIR #{app_dir}"

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock",  :backlog => 1024

# Logging
stderr_path "/web-app/shared/log/unicorn.stderr.log"
stdout_path "/web-app/shared/log/unicorn.stdout.log"

# Set master PID location
pid "#/web-app/shared/pids/unicorn.pid"



