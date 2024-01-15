class ApiClient
  def initialize(url:, auth_key:)
    @client = Faraday.new(
      url: url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{auth_key}"
      },
    )
  end

  def post_request(body)
    response = @client.post { |req| req.body = body.to_json }

    response.success? ? JSON.parse(response.body) : raise(ImageGenerationError.new(response.body))
  end
end
