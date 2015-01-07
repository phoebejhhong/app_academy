Rails.application.routes.draw do
  root to: "cats#index"
  resources :cats, except: [:destroy]
  resources :cat_rental_requests do
    patch "approve", to: "cat_rental_requests#approve"
    patch "deny", to: "cat_rental_requests#deny"
  end
end
