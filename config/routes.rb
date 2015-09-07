

Rails.application.routes.draw do

  root to: "single_views#home"

  devise_for :users, controllers: { registrations: "tutor_registration" }
  resources :tutors, :tutor_courses, :slots

  get '/search' => 'single_views#tutor_search'
  get '/restricted_access' => 'single_views#restricted_access'

  resources :users, only: [:update], path: '' do
    scope module: :dashboard do
      member do
          get  '/dashboard/home'                            => 'home#index'
          get  '/dashboard/schedule'                        => 'schedule#index'
          get  '/dashboard/courses'                         => 'courses#index'
          get  '/dashboard/profile'                         => 'profile#index'
          get  '/dashboard/edit_profile'                    => 'profile#edit'
          get  '/dashboard/settings/account_settings'       => 'settings#account_settings'
          get  '/dashboard/settings/tutor_settings'         => 'settings#tutor_settings'
          get  '/dashboard/settings/profile_settings'       => 'settings#profile_settings'
          get  '/dashboard/settings/appointment_settings'   => 'settings#appointment_settings'
          get  '/dashboard/settings/payment_settings'       => 'settings#payment_settings'
      end
    end
  end

  namespace :admin do
    get 'home'   => 'home#index'

    resources :tutors do
      collection { match 'search' => 'tutors#search', via: [:get, :post], as: :search }
    end

    resources :students do 
       collection { match 'search' => 'students#search', via: [:get, :post], as: :search }
    end
    
    resources :appointments do
      collection { match 'search' => 'appointments#search', via: [:get, :post], as: :search }
    end
    
    resources :slots do
      collection { match 'search' => 'slots#search', via: [:get, :post], as: :search }
    end
    
    resources :schools do 
      collection { match 'search' => 'schools#search', via: [:get, :post], as: :search }
    end

    resources :courses do
      collection do
        match 'search' => 'courses#search', via: [:get, :post], as: :search
        post 'new_course_list' => 'courses#new_course_list'
        post 'review_new_course_list' => 'courses#review_new_course_list'
        post 'create_new_course_list' => 'courses#create_new_course_list'
      end
    end

    resources :tutors       do collection { match 'search' => 'tutors#search', via: [:get, :post], as: :search } end
    resources :students     do collection { match 'search' => 'students#search', via: [:get, :post], as: :search } end
    resources :appointments do collection { match 'search' => 'appointments#search', via: [:get, :post], as: :search } end
    resources :slots        do collection { match 'search' => 'slots#search', via: [:get, :post], as: :search } end
    resources :schools      do collection { match 'search' => 'schools#search', via: [:get, :post], as: :search } end
    
    get 'home'   => 'home#index'

  end # end of 'admin' namespace

  # the 'only: [...]' syntax below after 'resources: collection_name' manually specifies which actions we want for a resource in order to avoid many extra, unused routes
  namespace :api, defaults: {format: :json} do
    namespace :v1 do 
      resources :schools, only: [] do 
        resources :subjects, only: [:index] do 
          resources :courses, only: [:index]
        end
      end
      resources :tutors, only: [] do 
        resources :slots, only: [:index, :show, :create, :update, :destroy]
        resources :appointments, controller: 'tutor_appointments'   
      end
      resources :students, only: [] do
        resources :appointments, controller: 'student_appointments'
      end
      get '/search/tutors' => 'search#tutors'
    end

  end

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

end
