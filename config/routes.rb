Rails.application.routes.draw do
  resources :choices do
    member do
      get 'result'
      get 'wrap'
      post 'selection'
      get 'confirm'
    end
  end
  resource :welcome, :only => ["index"]
  root :to => "welcome#index"
end
