# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, 
    controllers: {
      confirmations: 'users/confirmations',
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      omniauth_callbacks: 'omni_auth'
    }

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get 'logout', to: 'users/registrations#new'
    get 'forgot_password', to: 'users/passwords#new'
    get 'reset_password', to: 'users/passwords#edit'
  end

  # Account
  namespace :account do
    resources :transactions, :only => [:create], :controller => 'transactions', as: "transactions"
    resources :formrequests, :controller => 'form_requests', as: "form_requests"
    resources :requests, :controller => 'requests', as: "requests"
    resources :notifications, :only => [:show], :controller => 'notifications', as: "notifications"
    resources :messages, :only => [:index, :show, :create], :controller => 'messages', as: "messages"
    resources :users, :only => [:index, :new, :create, :edit, :update, :destroy], :controller => 'users', as: "users"
    resources :orders, :only => [:index, :show, :create, :update], :controller => 'orders', as: "orders"
    resources :products, :controller => 'products', :only => [:index] do
      get 'buy', on: :member
    end
    resources :documents, :only => [:index] do
      member do
        delete :remove
        post :upload
      end
    end
  end
  resource :account, only: [:index, :show, :edit, :update]
  get  '/account/credits',            to: 'account/transactions#index', as: 'account_credits'  
  get  '/account/users/:id/requests', to: 'account/users#requests', as: 'account_users_requests'
  post '/account/edit',               to: 'accounts#update'
  get  '/account/public',             to: 'accounts#public', as: 'account_public_edit'
  get  '/account/public/backgrounds', to: 'accounts#public_backgrounds', as: 'account_public_backgrounds_choose'
  get  '/account/public/info_changed', to: 'accounts#public_info_changed', as: 'account_public_info_changed'
  post '/account/documents/confirm',  to: 'account/documents#confirm'
  post '/account/documents/confirm',  to: 'account/documents#confirm'
  post '/account/notifications/mark_as_read', to: 'account/notifications#mark_as_read'
  
  # Public company pages
  get '/aziende/:id',                 to: 'account/users#show', as: "account_public"
  get '/aziende/:id/m',               to: 'account/users#modal', as: "account_public_modal"

  # PayPal Checkout
  post '/account/orders/create_order',  to: 'account/orders#create_order',  as: "create_order"
  post '/account/orders/capture_order', to: 'account/orders#capture_order', as: "capture_order"
  post '/account/orders/retrieve_order', to: 'account/orders#retrieve_order', as: "retrieve_order"

  # FormRequest - Forward & Modal
  get  '/account/formrequests/:id/modal',    to: 'account/form_requests#showmodal', as: 'account_form_request_showmodal'
  get  '/account/formrequests/:id/requests', to: 'account/form_requests#requests', as: 'account_form_request_requests_modal'
  get  '/account/formrequests/:id/forward',  to: 'account/form_requests#forward', as: 'account_form_request_forward'
  post '/account/formrequests/:id/forward',  to: 'account/form_requests#confirm', as: 'account_form_request_confirm'
  post '/account/formrequests/:id/archive',  to: 'account/form_requests#archive', as: 'account_form_request_archive'

  # Request - Modal
  get  '/account/requests/:id/modal',        to: 'account/requests#showmodal', as: 'account_request_showmodal'
  get  '/account/requests/:id/archivemodal', to: 'account/requests#showarchivemodal', as: 'account_request_showarchivemodal'
  post '/account/requests/:id/archive',      to: 'account/requests#archive', as: 'account_request_archive'

  # Documents - Modal
  get  '/account/documents/:id/modal',    to: 'account/documents#showmodal', as: 'account_documents_showmodal'
  post '/account/documents/:id/approve',  to: 'account/documents#approve', as: 'account_document_approve'
  post '/account/documents/:id/reject',   to: 'account/documents#reject', as: 'account_document_reject'

  # Messages (public)
  resources :messages, :only => [:index, :show, :create], :controller => 'messages'

  # Newsletter
  get  '/account/users/newsletter', to: 'account/users#newsletter', as: 'account_users_newsletter'
  post '/account/users/newsletter', to: 'account/users#newsletter', as: 'account_users_newsletter_send'

  # Product
  get  '/account/products/:id/modal', to: 'account/products#modal', as: 'account_product_modal'

  # Users Search
  get  '/account/users/search', to: 'account/users#search', as: 'account_users_search'

  # Admin - Add Stuff
  post '/account/users/:id/add_subscription',    to: 'account/users#add_subscription',    as: 'account_users_add_subscription'
  post '/account/users/:id/remove_subscription', to: 'account/users#remove_subscription', as: 'account_users_remove_subscription'
  post '/account/users/:id/add_credits',         to: 'account/users#add_credits',         as: 'account_users_add_credits'

  # Contact Form Submit
  resource :contact_form, :only => [:create]

  # Settings 
  namespace :settings do
    resources :categories, :only => [:index, :create, :update, :edit, :destroy], :controller => 'categories', as: "categories"
    resources :services,   :only => [:index, :create, :update, :destroy], :controller => 'services', as: "services"
    resources :siteinfo,   :only => [:index, :create, :update, :destroy], :controller => 'siteinfos', as: "siteinfos"
  end
  resources :settings, only: [:index, :show, :edit, :update]
  post '/settings/category/assoc', to: 'settings/categories#assoc', as: 'settings_category_services_assoc'

  # Servizi (public)
  get 'servizi'       => 'application#category'
  get 'servizi/:key'  => 'application#category'
  post 'servizi/:key' => 'form_requests#create', as: 'submit_formrequest'

  # Pages and stuff...
  get 'users', to: 'accounts#index'         # it manages the refresh on wrong registration page
  get 'pages/:slug'       => 'pages#show', as: 'page_show'
  get 'pages/:slug/modal' => 'pages#modal', as: 'page_show_modal'

  # Sitemap
  resources :sitemap, :only => :index
  get "sitemap.xml" => "sitemap#index", format: :xml, as: :sitemap

  # Root path
  root to: 'application#home'

end
