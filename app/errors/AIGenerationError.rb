class AIGenerationError < StandardError
  def initialize(message)
    super("AI engine generation error: #{message}")
  end
end
