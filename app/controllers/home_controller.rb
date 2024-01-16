class HomeController < ApplicationController
  before_action :get_prompt

  def home
    @prompt_size = @prompt.split(" ").each_with_index.map { |word, index| [index, word.size] }
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

  def get_prompt
    @prompt = Redis.new.get("prompt")
  end
end
