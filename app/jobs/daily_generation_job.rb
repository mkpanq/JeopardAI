require "sidekiq-scheduler"
require "redis"
require "open-uri"

class DailyGenerationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    prompt, image_url = Generator.new.call
    redis = Redis.new

    open("#{Rails.root}/public/prompt_image.jpg", 'wb') do |file|
      file << URI.open(image_url).read
    end

    prompt_helper = prompt.split(" ").map do |word|
      random_index = rand(0...word.length)
      transformed_str = '_' * word.length
      transformed_str[random_index] = word[random_index]
      transformed_str.split("").join(" ")
    end.join(";")

    redis.set("generated_at", Date.today.to_formatted_s(:long))
    redis.set("prompt", prompt)
    redis.set("prompt_helper", prompt_helper)
  end
end
