Testapp::Application.routes.draw do

  match 'home/dashboard' => 'home#dashboard'

  authenticated :user do
    root :to => 'home#dashboard'
  end
  root :to => "home#index"

  devise_for :users
  
  resources :topics do
    member do
      post 'add_invitees'
      post 'add_comments'
      post 'add_links'
    end
  end

  resources :links do
    post 'add_notes', on: :member
  end
end
