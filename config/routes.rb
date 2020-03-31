Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations, :sessions], controllers: { sessions: "sessions", registrations: "registrations" }
  as :user do
    post 'users' => 'registrations#create', :as => 'user_registration'

    post 'users/sign_in' => 'devise/sessions#create', :as => 'user_session'
    delete 'users/sign_out' => 'sessions#destroy', :as => 'destroy_user_session'

    get 'profiles/show/:id', to: 'profiles#show'
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'followers' => 'followers#create', :as => 'follower_registration'
end
