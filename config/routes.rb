Boomerang::Application.routes.draw do

  resources :sessions

  resources :users

  # This has to come first because otherwise it matches 'show'. Gggghhhhrrrrr.
  match '/invoices/load', :to => 'invoices#load', :via => :get
  match '/invoices/delete_file', :to => 'invoices#delete_file', :via => :get
  match '/invoices/view_file', :to => 'invoices#view_file', :via => :get

  resources :invoices do
    get 'files', :on => :collection
    get 'delete_all', :on => :collection
  end

  ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'matching', 'matching'
  end
  resources :matching, :as => "matching" do
    get 'do_match', :on => :collection
    get 'delete_all', :on => :collection
  end

  match 'offers', :to => "offers#index", :via => :get
  match 'bids', :to => "bids#index", :via => :get

  resources :clients do
    get 'offers', :on => :member
    get 'bids', :on => :member
    get 'match', :on => :member
    resources :offers do
      get 'accept', :on => :member
    end
    resources :bids do
      get 'accept', :on => :member
    end
  end

  resources :audits do
    get 'delete_all', :on => :collection
  end

  resources :demos do
    get 'load', :on => :member
    get 'add', :on => :member
  end

  match '/reports', :to => 'reports#index'

  match '/home', :to => 'main#welcome'
  match '/contact', :to => 'main#contact'
  match '/about', :to => 'main#about'
  match '/help', :to => 'main#help'
  match '/jobs', :to => 'main#jobs'
  match '/whats_new', :to => 'main#whats_new'
  match 'search', :to => 'main#search'

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  root :to => "main#welcome"

end
