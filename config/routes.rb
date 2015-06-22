# == Route Map
#
#                          Prefix Verb   URI Pattern                               Controller#Action
#       register_or_sign_in_tutor GET    /tutors/:id/register_or_sign_in(.:format) tutors#register_or_sign_in
#           visitor_sign_in_tutor GET    /tutors/:id/visitor_sign_in(.:format)     tutors#visitor_sign_in
#           visitor_sign_up_tutor GET    /tutors/:id/visitor_sign_up(.:format)     tutors#visitor_sign_up
#       create_tutor_course_tutor POST   /tutors/:id/create_tutor_course(.:format) tutors#create_tutor_course
#              visitor_new_tutors GET    /tutors/visitor_new(.:format)             tutors#visitor_new
#           visitor_create_tutors POST   /tutors/visitor_create(.:format)          tutors#visitor_create
#                   tutor_courses POST   /tutor_courses(.:format)                  tutor_courses#create
#                new_tutor_course GET    /tutor_courses/new(.:format)              tutor_courses#new
#                    tutor_course PATCH  /tutor_courses/:id(.:format)              tutor_courses#update
#                                 PUT    /tutor_courses/:id(.:format)              tutor_courses#update
#                                 DELETE /tutor_courses/:id(.:format)              tutor_courses#destroy
#                new_user_session GET    /users/sign_in(.:format)                  devise/sessions#new
#                    user_session POST   /users/sign_in(.:format)                  devise/sessions#create
#            destroy_user_session DELETE /users/sign_out(.:format)                 devise/sessions#destroy
#                   user_password POST   /users/password(.:format)                 devise/passwords#create
#               new_user_password GET    /users/password/new(.:format)             devise/passwords#new
#              edit_user_password GET    /users/password/edit(.:format)            devise/passwords#edit
#                                 PATCH  /users/password(.:format)                 devise/passwords#update
#                                 PUT    /users/password(.:format)                 devise/passwords#update
#        cancel_user_registration GET    /users/cancel(.:format)                   devise_invitable/registrations#cancel
#               user_registration POST   /users(.:format)                          devise_invitable/registrations#create
#           new_user_registration GET    /users/sign_up(.:format)                  devise_invitable/registrations#new
#          edit_user_registration GET    /users/edit(.:format)                     devise_invitable/registrations#edit
#                                 PATCH  /users(.:format)                          devise_invitable/registrations#update
#                                 PUT    /users(.:format)                          devise_invitable/registrations#update
#                                 DELETE /users(.:format)                          devise_invitable/registrations#destroy
#               user_confirmation POST   /users/confirmation(.:format)             devise/confirmations#create
#           new_user_confirmation GET    /users/confirmation/new(.:format)         devise/confirmations#new
#                                 GET    /users/confirmation(.:format)             devise/confirmations#show
#          accept_user_invitation GET    /users/invitation/accept(.:format)        devise/invitations#edit
#          remove_user_invitation GET    /users/invitation/remove(.:format)        devise/invitations#destroy
#                 user_invitation POST   /users/invitation(.:format)               devise/invitations#create
#             new_user_invitation GET    /users/invitation/new(.:format)           devise/invitations#new
#                                 PATCH  /users/invitation(.:format)               devise/invitations#update
#                                 PUT    /users/invitation(.:format)               devise/invitations#update
#                  dashboard_user GET    /:id/dashboard(.:format)                  dashboard#home
#                   schedule_user GET    /:id/schedule(.:format)                   dashboard#schedule
#                    courses_user GET    /:id/courses(.:format)                    dashboard#courses
#                    profile_user GET    /:id/profile(.:format)                    dashboard#profile
#                                 PUT    /:id/profile(.:format)                    dashboard#update_profile
#                   settings_user GET    /:id/settings(.:format)                   dashboard#settings
#                                 PUT    /:id/settings(.:format)                   dashboard#update_settings
#         change_profile_pic_user PUT    /:id/change_profile_pic(.:format)         dashboard#change_profile_pic
#      save_profile_pic_crop_user PUT    /:id/save_profile_pic_crop(.:format)      dashboard#save_profile_pic_crop
#                     tutors_user GET    /:id/tutors(.:format)                     dashboard#tutors_index
# update_tutor_active_status_user PUT    /:id/update_tutor_active_status(.:format) dashboard#update_tutor_active_status
#              destroy_tutor_user DELETE /:id/destroy_tutor(.:format)              dashboard#destroy_tutor
#                           upmin        /admin                                    Upmin::Engine
#                            root GET    /                                         static_pages#home
#
# Routes for Upmin::Engine:
#               root GET      /                                 upmin/models#dashboard
#    upmin_dashboard GET      /                                 upmin/models#dashboard
#       upmin_search GET|POST /m/:klass(.:format)               upmin/models#search
#    upmin_new_model GET      /m/:klass/new(.:format)           upmin/models#new
# upmin_create_model POST     /m/:klass/new(.:format)           upmin/models#create
#        upmin_model GET      /m/:klass/i/:id(.:format)         upmin/models#show
#                    PUT      /m/:klass/i/:id(.:format)         upmin/models#update
#       upmin_action POST     /m/:klass/i/:id/:method(.:format) upmin/models#action
#

Rails.application.routes.draw do
  resources :tutors, only: [] do
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
