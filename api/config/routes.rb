Rails.application.routes.draw do
  devise_for :admin_users, path: 'admin/account', class_name: 'AdminUser', skip: %I[registrations]

  namespace :admin do
    resources :admin_users
    resources :roles
    resources :users do
      resources :points, only: %i[index] do
        post :export, on: :collection
      end

      resources :discounts, controller: 'users/discounts', only: %i[index] do
        patch :refresh, on: :collection
      end
    end
    resources :segments
    resources :banking_infos, except: [:index]
    resources :products
    resources :discounts
    resources :uploaded_tickets, only: %i[index show] do
      member do
        post :review
      end
    end
    resources :reviewed_tickets, only: %i[index show] do
      member do
        post :recreate
      end
    end
    resources :digitalized_tickets, only: %i[index show] do
      member do
        post :review
      end
    end
    resources :unsegmented_tickets, only: %i[index show] do
      member do
        post :assign_segments
      end
    end
    resources :pending_payments, only: %i[index] do
      collection do
        post :export
      end
    end
    resources :tickets, only: [:index, :show]
    resource :database, only: %i[show], controller: 'database' do
      post :export
      get :import_user_segments, to: 'database#show_import_user_segments'
      post :import_user_segments
    end
    resource :async_database, only: %i[show destroy], controller: 'async_database' do
      post :export
      patch :cancel
      patch :download
    end
    resources :push_notifications, only: %i[new create] do
      collection do
        post :create_segment_notification
      end
    end
    resources :rewards, only: %i[new create]
    resources :audits, only: %i[new create]
    root to: 'users#index'
  end

  get 'not_authorized', to: 'application#not_authorized'

  devise_scope :user do
    get 'unlocked', as: 'unlocked', to:'api/v1/overrides/unlocks#unlocked'
    get 'overrides/unlocks/unlocked_failure', as: 'unlocked_failure', to: 'api/v1/overrides/unlocks#unlocked_failure'
  end

  mount_devise_token_auth_for 'User', at: '/api/v1/auth', controllers: {
    sessions: 'api/v1/overrides/sessions',
    registrations: 'api/v1/overrides/registrations',
    confirmations: 'api/v1/overrides/confirmations',
    passwords: 'api/v1/overrides/passwords',
    unlocks: 'api/v1/overrides/unlocks'
  }

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: %I[update]
      resources :banking_infos, only: %I[create update]
      resources :tickets, only: %I[create index]
      resources :user_discounts, only: %I[index]
      get 'user_discounts/obtained_discounts'
      get 'points/current_points'
      get 'points/history'
      get 'users/show'
      get 'discounts/landing_discounts'
      get 'discounts/show'
      get 'products/index'
      devise_scope :user do
        get 'auth/confirmed', controller: 'api/v1/overrides/confirmations', action: 'confirm'
      end
    end
  end

  devise_scope :user do
    get 'omniauth/confirmed', controller: 'api/v1/overrides/confirmations', action: 'confirm'
  end

  mount Sidekiq::Web, at: 'sidekiq'
end
