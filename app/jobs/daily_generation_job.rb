class DailyGenerationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    prompt, image_url = Generator.new.call
  end
end

# TODO:
# 1. Create background job for generation prompt and image
# 1. Storing image and prompt in database - need to use s3 or something like that
# 2. Caching image and prompt
# 3. Remove image and prompt from database after 24 hours
