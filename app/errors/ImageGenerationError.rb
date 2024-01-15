class ImageGenerationError < StandardError
  def initialize(message)
    super("Image generation error: #{message}")
  end
  attr_reader :state
end
