require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiq_creds, :username))
      ) &
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiq_creds, :password))
      )
  end
  mount Sidekiq::Web => "/sidekiq"

  root "home#home"
  post "answer" => "home#answer", as: :answer
  get "up" => "rails/health#show", as: :rails_health_check
end
