Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations, :sessions], controllers: { sessions: "sessions", registrations: "registrations" }
  as :user do
    post 'users' => 'registrations#create', :as => 'user_registration'

    post 'users/sign_in' => 'devise/sessions#create', :as => 'user_session'
    delete 'users/sign_out' => 'sessions#destroy', :as => 'destroy_user_session'

    get 'profiles/show/me', to: 'profiles#me'
    get 'profiles/show/:id', to: 'profiles#show'
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'followers' => 'followers#create', :as => 'follower_registration'

  post 'ideas' => 'ideas#create', :as => 'idea_registration'

  # Messages routes
  post 'messages', to: 'messages#create'
  get 'messages/list', to: 'messages#list'
  get 'messages/mark_red/:id', to: 'messages#mark_red'
  
  # Products routes
  post 'products', to: 'products#create'
  get 'products/list/:organization_id', to: 'products#list'

  post 'feedbacks', to: 'feedbacks#create'
end
