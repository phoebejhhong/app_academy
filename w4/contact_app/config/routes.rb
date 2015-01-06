Rails.application.routes.draw do
  # get 'users' => 'users#index', as: 'users'
  # post 'users' => 'users#create'
  # get 'users/new' => 'users#new', as: 'new_user'
  # get 'users/:id/edit' => 'users#edit', as: 'edit_user'
  # get 'users/:id' => 'users#show', as: 'user'
  # patch 'users/:id' => 'users#update'
  # put 'users/:id' => 'users#update'
  # delete 'users/:id' => 'users#destroy'
  resources :users, except: [:new, :edit] do
    resources :contacts, only: [:index]
    resources :comments, only: [:index]
    member do
      get 'favorites'
    end
  end
  resources :contacts, except: [:new, :edit, :index] do
    resources :comments, only: [:index]
  end
  resources :contact_shares, only: [:create, :destroy]

  # resources :contacts, :has_many => :comments
  # resources :users, :has_many => :comments

end
