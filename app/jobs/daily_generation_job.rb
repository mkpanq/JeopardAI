require "sidekiq-scheduler"
require "redis"
require "open-uri"

class DailyGenerationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    prompt, image_url = Generator.new.call
    redis = Redis.new

    open("#{Rails.root}/app/assets/images/prompt_image.jpg", 'wb') do |file|
      file << URI.open(image_url).read
    end

    prompt_helper = prompt.split(" ").map do |word|
      random_index = rand(0...word.length)
      transformed_str = '_' * word.length
      transformed_str[random_index] = word[random_index]
      transformed_str.split("").join(" ")
    end.join(";")

    redis.set("prompt", prompt)
    redis.set("prompt_helper", prompt_helper)
    redis.set("image_url", image_url)
  end
end
