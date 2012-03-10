Testapp::Application.routes.draw do

  match 'home/dashboard' => 'home#dashboard'

  authenticated :user do
    root :to => 'home#dashboard'
  end
  root :to => "home#index"

  devise_for :users
  
  resources :topics do
    post 'add_invitees', on: :member 
  end
  resources :links
end
