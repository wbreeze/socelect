Rails.application.routes.draw do
  resource :welcome, :only => ["index"]
  root :to => "welcome#index"
  get '/welcome/:page', controller: 'welcome', action: 'page_view'
  resources :choices do
    member do
      get 'result'
      get 'wrap'
    end
  end
  resources :preferences, only: %w(create show)
end
