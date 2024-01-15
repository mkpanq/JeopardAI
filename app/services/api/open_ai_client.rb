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
      return "Error during image generation - #{e.message}"
    end

    def get_prompt
      system_prompt = "You are a part of application called jeopardyAI. This application is similiar to popular game show Jeopardy. Users based on given image generated by AI have to guess the prompt which generated it. You are assistant for finding precise and short prompts to generate images. Prompts should be short and precise and not impossible to guess. You need to use english language. Return me nothing but ready prompt, without any additional words. Here are some examples of prompts:
        - Dog with a cool hat,
        - Red flower with a bee on it,
        - Old couple laughing on a bench,
        - Two beer bottles fight in the bar
        - Dog with two tails running after bird"

      response = ApiClient.new(
        url: ENV['OPEN_AI_TEXT_GENERATOR_URL'],
        auth_key: @api_key
      ).post_request(
  {
          "model": ENV['OPEN_AI_TEXT_MODEL'],
          "messages": [
            { "role": "system", "content": system_prompt },
            { "role": "user", "content": "Hello! Please generate me one prompt for jeopardyAI game." }
          ]
        }
      )

      response.dig("choices", 0, "message", "content")
    rescue => e
      return "Error during prompt generation - #{e.message}"
    end
  end
end
