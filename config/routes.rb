Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    resources :urls, only: %w[create index show]
      get 'analytics', to: 'urls#analytics'
  end

  scope module: 'api' do
    get '/:short_url', to: 'urls#redirect_short_url'
  end
end
