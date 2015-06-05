Rails.application.routes.draw do
  resources :tutors do
    member do
      get  '/dashboard' => 'dashboard#home'
      get  '/schedule'  => 'dashboard#schedule'
      get  '/courses'   => 'dashboard#courses'
      get  '/profile'   => 'dashboard#profile'
      get  '/settings'  => 'dashboard#settings'

      post '/profile'   => 'dashboard#apply_profile'
      post '/settings'  => 'dashboard#apply_settings'
    end
  end
  resources :courses
  resources :subjects
  resources :schools
  resources :dashboard
  devise_for :users

  mount Upmin::Engine => '/admin'
  root to: "static_pages#home"

end
