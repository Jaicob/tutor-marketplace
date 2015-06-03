Rails.application.routes.draw do
  resources :tutors
  resources :courses
  resources :subjects
  resources :schools
  resources :dashboard do
    collection do
      get '/schedule' => 'dashboard#schedule'
      get '/courses' => 'dashboard#courses'
      get '/profile' => 'dashboard#profile'
      get '/settings' => 'dashboard#settings'
    end
  end
  devise_for :users
  mount Upmin::Engine => '/admin'
  root to: "static_pages#home"

end
