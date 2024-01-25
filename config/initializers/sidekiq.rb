if ENV['RAILS_ENV'] == 'production'
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://redis:6379/0' }
  end
end
