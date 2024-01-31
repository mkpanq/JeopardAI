class HomeController < ApplicationController
  before_action :get_redis_client, :get_prompt_helpers
  before_action :get_prompt, only: [:answer]
  def home
  end

  def answer
    @errors = 0
    answer_table = params[:answer].downcase.split(" ")

    @prompt.downcase.split(" ").each_with_index do |prompt_word, index|
      prompt_word == answer_table[index] ? @errors : @errors += 1
    end

    turbo_stream
  end

  private

  def get_redis_client
    @redis ||= RedisConnection.connection
  end

  def get_prompt_helpers
    @prompt_helper = @redis.get("prompt_helper")
    @generated_at = @redis.get("generated_at")
  end

  def get_prompt
    @prompt = @redis.get("prompt")
  end
end
