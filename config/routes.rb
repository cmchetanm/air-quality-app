require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :locations, only: :index do
        collection do   
          get :fetch_air_pollution
          get :get_location_pollution_history
          get :avg_aqi_per_month_and_location
          get :average_aqi_per_location
          get :average_aqi_per_state
        end
      end
    end
  end
end
