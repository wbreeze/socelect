Socelect::Application.routes.draw do
  resources :choices do
    member do
      get 'finish'
      put 'publish'
      post 'selection'
      get 'confirm'
      get 'result'
    end
  end
 
  resource :welcome, :only => ["index"]
  root :to => "welcome#index"

end
