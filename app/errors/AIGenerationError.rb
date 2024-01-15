class AIGenerationError < StandardError
  def initialize(message)
    super("AI engine generation error: #{message}")
  end
  attr_reader :state
end
