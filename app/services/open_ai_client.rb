class OpenAIClient
  def initialize
    @api_key = Rails.application.credentials.open_ai.api_key
  end

  def get_image_url(prompt)
    response = ApiClient.new(
      url: ENV['OPEN_AI_IMAGE_GENERATOR_URL'],
      auth_key: @api_key
    ).post_request(
      {
        "model": ENV['OPEN_AI_IMAGE_MODEL'],
        "prompt": prompt,
        "n": 1,
        "size": ENV['OPEN_AI_IMAGE_DEFAULT_SIZE']
      }
    )

    response.dig("data", 0, "url")
  rescue => e
    return e.message
  end
end
