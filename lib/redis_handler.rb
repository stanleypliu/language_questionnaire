require 'redis'

class RedisHandler
  def initialize
    @redis = Redis.new
  end

  def all_runs
    @redis.lrange('runs', 0, -1)
  end

  def push(rating)
    @redis.rpush('runs', rating)
  end

  def delete_all_keys
    @redis.keys.each { |key| @redis.del(key) }
  end
end