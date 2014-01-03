APP_PATH = "/var/www/projects/mojazaliczka.pl/app"
worker_processes 1
working_directory APP_PATH # available in 0.94.0+
listen "/tmp/zaliczka.sock", :backlog => 64
listen 8080, :tcp_nopush => true
timeout 60
pid "/tmp/zaliczka.pid"
stderr_path "/var/log/unicorn/zaliczka.stderr.log"
stdout_path "/var/log/unicorn/zaliczka.stdout.log"
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
