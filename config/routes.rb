Rails.application.routes.draw do
  resource :welcome, :only => ["index"]
  root :to => "welcome#index"
  get '/welcome/:page', controller: 'welcome', action: 'page_view'
  resources :choices do
    member do
      get 'result'
      get 'wrap'
      post 'selection'
      get 'confirm'
    end
  end
end
