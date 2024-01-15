class HomeController < ApplicationController
  def home
    @prompt = Api::OpenAiClient.new.get_prompt
    p @prompt
    @image_url = Api::OpenAiClient.new.get_image_url(@prompt)
    p @image_url
  rescue => e
    flash[:error] = e.message
  end
end
