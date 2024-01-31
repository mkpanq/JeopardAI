module Clients::RedisConnection
  def self.connection
    $redis ||= ConnectionPool::Wrapper.new(size: ENV['REDIS_CONNECTION_POOL_SIZE'], timeout: 3) do
      Redis.new(url: ENV["REDIS_URL"])
    end
  end
end
