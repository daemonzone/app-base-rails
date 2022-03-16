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
    resources :notifications, :only => [:show], :controller => 'notifications', as: "notifications"
    resources :users, :only => [:index, :new, :create, :edit, :update, :destroy], :controller => 'users', as: "users"
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
  post '/account/documents/confirm',  to: 'account/documents#confirm'
  post '/account/notifications/mark_as_read', to: 'account/notifications#mark_as_read'

  # Documents - Modal
  get  '/account/documents/:id/modal',    to: 'account/documents#showmodal', as: 'account_documents_showmodal'
  post '/account/documents/:id/approve',  to: 'account/documents#approve', as: 'account_document_approve'
  post '/account/documents/:id/reject',   to: 'account/documents#reject', as: 'account_document_reject'

  # Newsletter
  get  '/account/users/newsletter', to: 'account/users#newsletter', as: 'account_users_newsletter'
  post '/account/users/newsletter', to: 'account/users#newsletter', as: 'account_users_newsletter_send'

  # Users Search
  get  '/account/users/search', to: 'account/users#search', as: 'account_users_search'

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
