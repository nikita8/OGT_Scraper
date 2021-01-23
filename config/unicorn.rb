# define paths and filenames
env = ENV['RACK_ENV']||'development'
deploy_to = "/home/ubuntu/Nikita/OGPScraper"
root_path = "#{deploy_to}/shared/"
pid_file = "#{deploy_to}/shared/tmp/pids/unicorn.pid"
socket_file= "#{deploy_to}/shared/sockets/unicorn.sock"
log_file = "#{root_path}/log/#{env}.log"
err_log = "#{root_path}/log/#{env}.log"
old_pid = pid_file + '.oldbin'

timeout 90

worker_processes  (env == 'production') ? 6 : 2

listen socket_file, :backlog => 128

pid pid_file
stderr_path err_log
stdout_path log_file

# make forks faster
preload_app true

# make sure that Bundler finds the Gemfile
before_exec do |server|
    ENV['BUNDLE_GEMFILE'] = "#{root_path}/Gemfile"
end

before_fork do |server, worker|
    old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  # Throttle the master from forking too quickly by sleeping.
  sleep 1
end

after_fork do |server, worker|
  # Process should be owned by deploy:deploy
  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'ubuntu', 'ubuntu'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
  end
end
