
Rails.application.routes.draw do
  resources :tutors, only: [:index, :new, :create, :show] do
    member do
      get 'register_or_sign_in'
      get 'visitor_sign_in'
      get 'visitor_sign_up'
      post 'create_tutor_course'
    end
    collection do
      get 'visitor_new'
      post 'visitor_create'
    end
  end
  resources :tutor_courses, only: [:new, :create, :update, :destroy]
  devise_for :users

  resources :users, only: [], path: '' do 
    member do       
      get  '/dashboard' => 'dashboard#home'
      get  '/schedule'  => 'dashboard#schedule'
      get  '/courses'   => 'dashboard#courses'
      get  '/profile'   => 'dashboard#profile'
      put  '/profile'   => 'dashboard#update_profile'
      get  '/settings'  => 'dashboard#settings'
      put  '/settings'  => 'dashboard#update_settings'
      put  '/change_profile_pic' => 'dashboard#change_profile_pic'
      put  '/save_profile_pic_crop' => 'dashboard#save_profile_pic_crop'
      # Admin only routes below
      get '/tutors' => 'dashboard#tutors_index' 
      put '/update_tutor_active_status' => 'dashboard#update_tutor_active_status'
      delete '/destroy_tutor' => 'dashboard#destroy_tutor'
    end
  end

  mount Upmin::Engine => '/admin'
  root to: "static_pages#home"

end
