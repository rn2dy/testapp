Testapp::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  match 'home/dashboard'    => 'home#dashboard'
  match 'home/about'        => 'home#about'
  match 'home/sys_notify'   => 'home#sys_notify'
  match 'home/bookmarklet'  => 'home#bookmarklet'

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

  # Bookmarklet
  get   'bookmarklet/index'      => 'bookmarklet#index'
  get   'bookmarklet/new_link'   => 'bookmarklet#new_link'
  get   'bookmarklet/new_topic'  => 'bookmarklet#new_topic'
  post  'bookmarklet/add_link'   => 'bookmarklet#add_link'
  post  'bookmarklet/login'    => 'bookmarklet#login'
  post  'bookmarklet/add_topic'  => 'bookmarklet#add_topic'

end
