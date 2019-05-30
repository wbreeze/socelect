Rails.application.routes.draw do
  resources :choices do
    member do
      get 'finish'
      patch 'publish'
      post 'selection'
      get 'confirm'
      get 'result'
      get 'wrap'
    end
  end

  resource :welcome, :only => ["index"]
  root :to => "welcome#index"
end
