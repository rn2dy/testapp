Testapp::Application.routes.draw do

  match 'home/dashboard' => 'home#dashboard'
  match 'home/about'     => 'home#about'

  authenticated :user do
    root :to => 'home#dashboard'
  end
  root :to => "home#index"
  
  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }
  devise_scope :user do
     post 'resend_password' => 'registrations#resend_password'
  end
  
  put 'settings' => 'settings#update'
  get 'settings/edit' => 'settings#edit'
  
  resources :topics do
    member do
      post 'add_invitees'
      post 'add_comments'
      post 'add_links'
      post 'refresh'
    end
  end

  resources :links do
    post 'add_notes', on: :member
  end

end
