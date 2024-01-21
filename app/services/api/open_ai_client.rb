module Api
  class OpenAiClient
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
      raise "Error during image generation - #{e.message}"
    end

    def get_prompt
      response = ApiClient.new(
        url: ENV['OPEN_AI_TEXT_GENERATOR_URL'],
        auth_key: @api_key
      ).post_request(
  {
          "model": ENV['OPEN_AI_TEXT_MODEL'],
          "messages": [
            { "role": "system", "content": OPEN_AI_CONFIG_PROMPT },
            { "role": "user", "content": OPEN_AI_ASKING_PROMPT }
          ]
        }
      )
      generated_prompt = response.dig("choices", 0, "message", "content")

      generated_prompt.gsub(/[[:punct:]]/,'') # Remove all punctuation
    rescue => e
      raise "Error during prompt generation - #{e.message}"
    end
  end
end
