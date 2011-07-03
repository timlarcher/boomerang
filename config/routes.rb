Boomerang::Application.routes.draw do

  resources :matching do
    get 'do_match', :on => :collection
  end

  resources :clients

  resources :audits do
    get 'delete_all', :on => :collection
  end

  resources :demos do
    get 'load', :on => :member
  end

  match '/home', :to => 'home#welcome'
  match '/contact', :to => 'main#contact'
  match '/about', :to => 'main#about'
  match '/help', :to => 'main#help'
  match '/jobs', :to => 'main#jobs'
  match '/whats_new', :to => 'main#whats_new'
  match 'search', :to => 'main#search'

  match '/signup', :to => 'players#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  root :to => "main#welcome"

end
