Rails.application.routes.draw do
  
  devise_for :admin

  namespace :admin do
    resources :categories
    resources :products do
      member do
        delete :delete_primary_image
        delete :delete_supporting_image
      end
    end
    namespace :products do
      post 'csv_upload'
    end
  end
  
  root 'home#index'
  get 'admin', to: 'admin#index'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
