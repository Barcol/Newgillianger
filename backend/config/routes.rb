Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "messages/hello", to: "messages#hello"

  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end

  resources :ceremonies, only: [ :index, :show, :create, :destroy, :update ], concerns: :paginatable
  resources :products, only: [ :index, :create, :destroy ], concerns: :paginatable do
    member do
      post :restore
    end
  end
end
