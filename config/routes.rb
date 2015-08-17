# == Route Map
#

Rails.application.routes.draw do

  root to: "single_views#home"

  resources :tutors do
    member do
      # Custom routes below are necessary to allow visitors without user accounts to create tutor profiles before creating a user account yet still automatically link the two
      get 'register_or_sign_in'
      get 'visitor_sign_in'
      get 'visitor_sign_up'
      # Custom route for redirect back to Dashboard settings page after update
      patch 'update_settings'
    end
    collection do
      # Custom routes below are necessary to allow visitors without user accounts to create tutor profiles before creating a user account yet still automatically link the two
      get 'visitor_new'
      post 'visitor_create'
    end
  end

  devise_for :users
  resources :tutor_courses
  resources :slots

  get '/search' => 'single_views#tutor_search'

  resources :users, only: [:update], path: '' do
    scope module: :dashboard do
      member do
          get  '/dashboard/home'         => 'home#index'
          get  '/dashboard/schedule'     => 'schedule#index'
          get  '/dashboard/courses'      => 'courses#index'
          get  '/dashboard/profile'      => 'profile#index'
          get  '/dashboard/edit_profile' => 'profile#edit'
          get  '/dashboard/settings'     => 'settings#index'
          get  '/dashboard/tutors'       => 'tutors#index'
      end
    end
  end

  namespace :admin do
    resources :courses do
      collection do
        match 'search' => 'courses#search', via: [:get, :post], as: :search
        post 'new_course_list' => 'courses#new_course_list'
        post 'review_new_course_list' => 'courses#review_new_course_list'
        post 'create_new_course_list' => 'courses#create_new_course_list'
      end
    end
    resources :tutors do
      collection do
        match 'search' => 'tutors#search', via: [:get, :post], as: :search
      end
    end
    resources :students do 
       collection do
        match 'search' => 'students#search', via: [:get, :post], as: :search
      end
    end
    resources :appointments do
      collection do
        match 'search' => 'appointments#search', via: [:get, :post], as: :search
      end
    end
    resources :slots do
      collection do
        match 'search' => 'slots#search', via: [:get, :post], as: :search
      end
    end
    resources :schools do 
      collection do
        match 'search' => 'schools#search', via: [:get, :post], as: :search
      end
    end
    get 'home'   => 'home#index'
  end

  mount API => '/'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
