class HomeController < ApplicationController
  def home
  end

  def answer
    p params[:answer]
    redirect_to root_path
  end
end
