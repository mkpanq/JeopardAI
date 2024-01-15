class Generator
  def initialize
    @open_ai_client = OpenAiClient.new
  end

  def call
    prompt = @open_ai_client.get_prompt
    image_url = @open_ai_client.get_image_url(prompt)

    [prompt, image_url]
  end
end
