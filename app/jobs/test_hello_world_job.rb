require "sidekiq-scheduler"
require "redis"
require "open-uri"

class TestHelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    prompt = "https://picsum.photos/1024/1024"
    redis = Redis.new

    open("#{Rails.root}/app/assets/images/prompt_image.jpg", 'wb') do |file|
      file << URI.open(prompt).read
    end

    redis.set("prompt", "Some prompt for redis #{DateTime.now}")
    redis.set("image_url", prompt)
  end
end
