class HomeController < ApplicationController
  def home
    @prompt = Api::OpenAiClient.new.get_prompt
  end
end
