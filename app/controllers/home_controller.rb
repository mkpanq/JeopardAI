class HomeController < ApplicationController
  def home
    image_generate_connection = Faraday.new(
      url: "https://api.openai.com/v1/images/generations",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{Rails.application.credentials.open_ai.api_key}"
      },
    )

    @response = image_generate_connection.post do |req|
      req.body = {
        "model": "dall-e-2",
        "prompt": "random cat image",
        "n": 1,
        "size": "512x512"
      }.to_json
    end
  end
end
