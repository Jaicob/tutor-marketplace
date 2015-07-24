# == Route Map
#
#                      Prefix Verb   URI Pattern                                Controller#Action
#   register_or_sign_in_tutor GET    /tutors/:id/register_or_sign_in(.:format)  tutors#register_or_sign_in
#       visitor_sign_in_tutor GET    /tutors/:id/visitor_sign_in(.:format)      tutors#visitor_sign_in
#       visitor_sign_up_tutor GET    /tutors/:id/visitor_sign_up(.:format)      tutors#visitor_sign_up
#  update_active_status_tutor PUT    /tutors/:id/update_active_status(.:format) tutors#update_active_status
#      destroy_by_admin_tutor DELETE /tutors/:id/destroy_by_admin(.:format)     tutors#destroy_by_admin
#       update_settings_tutor PUT    /tutors/:id/update_settings(.:format)      tutors#update_settings
#          visitor_new_tutors GET    /tutors/visitor_new(.:format)              tutors#visitor_new
#       visitor_create_tutors POST   /tutors/visitor_create(.:format)           tutors#visitor_create
#                      tutors GET    /tutors(.:format)                          tutors#index
#                             POST   /tutors(.:format)                          tutors#create
#                   new_tutor GET    /tutors/new(.:format)                      tutors#new
#                  edit_tutor GET    /tutors/:id/edit(.:format)                 tutors#edit
#                       tutor GET    /tutors/:id(.:format)                      tutors#show
#                             PATCH  /tutors/:id(.:format)                      tutors#update
#                             PUT    /tutors/:id(.:format)                      tutors#update
#                             DELETE /tutors/:id(.:format)                      tutors#destroy
#            new_user_session GET    /users/sign_in(.:format)                   devise/sessions#new
#                user_session POST   /users/sign_in(.:format)                   devise/sessions#create
#        destroy_user_session DELETE /users/sign_out(.:format)                  devise/sessions#destroy
#               user_password POST   /users/password(.:format)                  devise/passwords#create
#           new_user_password GET    /users/password/new(.:format)              devise/passwords#new
#          edit_user_password GET    /users/password/edit(.:format)             devise/passwords#edit
#                             PATCH  /users/password(.:format)                  devise/passwords#update
#                             PUT    /users/password(.:format)                  devise/passwords#update
#    cancel_user_registration GET    /users/cancel(.:format)                    devise_invitable/registrations#cancel
#           user_registration POST   /users(.:format)                           devise_invitable/registrations#create
#       new_user_registration GET    /users/sign_up(.:format)                   devise_invitable/registrations#new
#      edit_user_registration GET    /users/edit(.:format)                      devise_invitable/registrations#edit
#                             PATCH  /users(.:format)                           devise_invitable/registrations#update
#                             PUT    /users(.:format)                           devise_invitable/registrations#update
#                             DELETE /users(.:format)                           devise_invitable/registrations#destroy
#           user_confirmation POST   /users/confirmation(.:format)              devise/confirmations#create
#       new_user_confirmation GET    /users/confirmation/new(.:format)          devise/confirmations#new
#                             GET    /users/confirmation(.:format)              devise/confirmations#show
#      accept_user_invitation GET    /users/invitation/accept(.:format)         devise/invitations#edit
#      remove_user_invitation GET    /users/invitation/remove(.:format)         devise/invitations#destroy
#             user_invitation POST   /users/invitation(.:format)                devise/invitations#create
#         new_user_invitation GET    /users/invitation/new(.:format)            devise/invitations#new
#                             PATCH  /users/invitation(.:format)                devise/invitations#update
#                             PUT    /users/invitation(.:format)                devise/invitations#update
#                     courses GET    /courses(.:format)                         courses#index
#                             POST   /courses(.:format)                         courses#create
#                  new_course GET    /courses/new(.:format)                     courses#new
#                 edit_course GET    /courses/:id/edit(.:format)                courses#edit
#                      course GET    /courses/:id(.:format)                     courses#show
#                             PATCH  /courses/:id(.:format)                     courses#update
#                             PUT    /courses/:id(.:format)                     courses#update
#                             DELETE /courses/:id(.:format)                     courses#destroy
#                     schools GET    /schools(.:format)                         schools#index
#                             POST   /schools(.:format)                         schools#create
#                  new_school GET    /schools/new(.:format)                     schools#new
#                 edit_school GET    /schools/:id/edit(.:format)                schools#edit
#                      school GET    /schools/:id(.:format)                     schools#show
#                             PATCH  /schools/:id(.:format)                     schools#update
#                             PUT    /schools/:id(.:format)                     schools#update
#                             DELETE /schools/:id(.:format)                     schools#destroy
#                    subjects GET    /subjects(.:format)                        subjects#index
#                             POST   /subjects(.:format)                        subjects#create
#                 new_subject GET    /subjects/new(.:format)                    subjects#new
#                edit_subject GET    /subjects/:id/edit(.:format)               subjects#edit
#                     subject GET    /subjects/:id(.:format)                    subjects#show
#                             PATCH  /subjects/:id(.:format)                    subjects#update
#                             PUT    /subjects/:id(.:format)                    subjects#update
#                             DELETE /subjects/:id(.:format)                    subjects#destroy
#               tutor_courses GET    /tutor_courses(.:format)                   tutor_courses#index
#                             POST   /tutor_courses(.:format)                   tutor_courses#create
#            new_tutor_course GET    /tutor_courses/new(.:format)               tutor_courses#new
#           edit_tutor_course GET    /tutor_courses/:id/edit(.:format)          tutor_courses#edit
#                tutor_course GET    /tutor_courses/:id(.:format)               tutor_courses#show
#                             PATCH  /tutor_courses/:id(.:format)               tutor_courses#update
#                             PUT    /tutor_courses/:id(.:format)               tutor_courses#update
#                             DELETE /tutor_courses/:id(.:format)               tutor_courses#destroy
#         dashboard_home_user GET    /:id/dashboard/home(.:format)              dashboard#home
#     dashboard_schedule_user GET    /:id/dashboard/schedule(.:format)          dashboard#schedule
#      dashboard_courses_user GET    /:id/dashboard/courses(.:format)           dashboard#courses
#      dashboard_profile_user GET    /:id/dashboard/profile(.:format)           dashboard#profile
# dashboard_edit_profile_user GET    /:id/dashboard/edit_profile(.:format)      dashboard#edit_profile
#     dashboard_settings_user GET    /:id/dashboard/settings(.:format)          dashboard#settings
#       dashboard_tutors_user GET    /:id/dashboard/tutors(.:format)            dashboard#tutors
#                        user PATCH  /:id(.:format)                             users#update
#                             PUT    /:id(.:format)                             users#update
#                        root GET    /                                          static_pages#home
#                         api        /                                          API
#

Rails.application.routes.draw do
  
  resources :tutors do
    member do
      # Custom routes below are necessary to allow visitors without user accounts to create tutor profiles before creating a user account yet still automatically link the two
      get 'register_or_sign_in'
      get 'visitor_sign_in'
      get 'visitor_sign_up'
      # Custom routes  for Admin to update tutors
      put 'update_active_status'
      delete 'destroy_by_admin'
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
  resources :courses
  resources :schools
  resources :subjects
  resources :tutor_courses


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

  # scope module: :admin do 
  namespace :admin do
    resources :courses
    resources :schools
    resources :tutors
  end

  root to: "static_pages#home"

  mount API => '/'

end
