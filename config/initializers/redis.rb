def redis_conf
  YAML.load_file('config/redis.yml')[ENV['RAILS_ENV'] || 'development']
end

def redis
  @redis ||= Redis.new(redis_conf)
end