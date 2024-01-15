require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # TODO: Make sidekiq secure behind a login
  mount Sidekiq::Web => "/sidekiq"

  root "home#home"
  get "up" => "rails/health#show", as: :rails_health_check
end
