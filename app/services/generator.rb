class Generator
  def initialize
    @open_ai_client = OpenAiClient.new
  end

  def call
    @prompt = @open_ai_client.get_prompt
    @image_url = @open_ai_client.get_image_url(@prompt)
  end
end

# TODO:
# 1. Create background job for generation prompt and image
# 1. Storing image and prompt in database - need to use s3 or something like that
# 2. Caching image and prompt
# 3. Remove image and prompt from database after 24 hours
