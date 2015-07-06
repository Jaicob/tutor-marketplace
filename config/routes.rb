# == Route Map
#
#                     Prefix Verb   URI Pattern                                Controller#Action
# update_active_status_tutor PUT    /tutors/:id/update_active_status(.:format) tutors#update_active_status
#  register_or_sign_in_tutor GET    /tutors/:id/register_or_sign_in(.:format)  tutors#register_or_sign_in
#      visitor_sign_in_tutor GET    /tutors/:id/visitor_sign_in(.:format)      tutors#visitor_sign_in
#      visitor_sign_up_tutor GET    /tutors/:id/visitor_sign_up(.:format)      tutors#visitor_sign_up
#  create_tutor_course_tutor POST   /tutors/:id/create_tutor_course(.:format)  tutors#create_tutor_course
#         visitor_new_tutors GET    /tutors/visitor_new(.:format)              tutors#visitor_new
#      visitor_create_tutors POST   /tutors/visitor_create(.:format)           tutors#visitor_create
#                     tutors GET    /tutors(.:format)                          tutors#index
#                            POST   /tutors(.:format)                          tutors#create
#                  new_tutor GET    /tutors/new(.:format)                      tutors#new
#                 edit_tutor GET    /tutors/:id/edit(.:format)                 tutors#edit
#                      tutor GET    /tutors/:id(.:format)                      tutors#show
#                            PATCH  /tutors/:id(.:format)                      tutors#update
#                            PUT    /tutors/:id(.:format)                      tutors#update
#                            DELETE /tutors/:id(.:format)                      tutors#destroy
#           new_user_session GET    /users/sign_in(.:format)                   devise/sessions#new
#               user_session POST   /users/sign_in(.:format)                   devise/sessions#create
#       destroy_user_session DELETE /users/sign_out(.:format)                  devise/sessions#destroy
#              user_password POST   /users/password(.:format)                  devise/passwords#create
#          new_user_password GET    /users/password/new(.:format)              devise/passwords#new
#         edit_user_password GET    /users/password/edit(.:format)             devise/passwords#edit
#                            PATCH  /users/password(.:format)                  devise/passwords#update
#                            PUT    /users/password(.:format)                  devise/passwords#update
#   cancel_user_registration GET    /users/cancel(.:format)                    devise_invitable/registrations#cancel
#          user_registration POST   /users(.:format)                           devise_invitable/registrations#create
#      new_user_registration GET    /users/sign_up(.:format)                   devise_invitable/registrations#new
#     edit_user_registration GET    /users/edit(.:format)                      devise_invitable/registrations#edit
#                            PATCH  /users(.:format)                           devise_invitable/registrations#update
#                            PUT    /users(.:format)                           devise_invitable/registrations#update
#                            DELETE /users(.:format)                           devise_invitable/registrations#destroy
#          user_confirmation POST   /users/confirmation(.:format)              devise/confirmations#create
#      new_user_confirmation GET    /users/confirmation/new(.:format)          devise/confirmations#new
#                            GET    /users/confirmation(.:format)              devise/confirmations#show
#     accept_user_invitation GET    /users/invitation/accept(.:format)         devise/invitations#edit
#     remove_user_invitation GET    /users/invitation/remove(.:format)         devise/invitations#destroy
#            user_invitation POST   /users/invitation(.:format)                devise/invitations#create
#        new_user_invitation GET    /users/invitation/new(.:format)            devise/invitations#new
#                            PATCH  /users/invitation(.:format)                devise/invitations#update
#                            PUT    /users/invitation(.:format)                devise/invitations#update
#                    courses GET    /courses(.:format)                         courses#index
#                            POST   /courses(.:format)                         courses#create
#                 new_course GET    /courses/new(.:format)                     courses#new
#                edit_course GET    /courses/:id/edit(.:format)                courses#edit
#                     course GET    /courses/:id(.:format)                     courses#show
#                            PATCH  /courses/:id(.:format)                     courses#update
#                            PUT    /courses/:id(.:format)                     courses#update
#                            DELETE /courses/:id(.:format)                     courses#destroy
#                    schools GET    /schools(.:format)                         schools#index
#                            POST   /schools(.:format)                         schools#create
#                 new_school GET    /schools/new(.:format)                     schools#new
#                edit_school GET    /schools/:id/edit(.:format)                schools#edit
#                     school GET    /schools/:id(.:format)                     schools#show
#                            PATCH  /schools/:id(.:format)                     schools#update
#                            PUT    /schools/:id(.:format)                     schools#update
#                            DELETE /schools/:id(.:format)                     schools#destroy
#                   subjects GET    /subjects(.:format)                        subjects#index
#                            POST   /subjects(.:format)                        subjects#create
#                new_subject GET    /subjects/new(.:format)                    subjects#new
#               edit_subject GET    /subjects/:id/edit(.:format)               subjects#edit
#                    subject GET    /subjects/:id(.:format)                    subjects#show
#                            PATCH  /subjects/:id(.:format)                    subjects#update
#                            PUT    /subjects/:id(.:format)                    subjects#update
#                            DELETE /subjects/:id(.:format)                    subjects#destroy
#              tutor_courses GET    /tutor_courses(.:format)                   tutor_courses#index
#                            POST   /tutor_courses(.:format)                   tutor_courses#create
#           new_tutor_course GET    /tutor_courses/new(.:format)               tutor_courses#new
#          edit_tutor_course GET    /tutor_courses/:id/edit(.:format)          tutor_courses#edit
#               tutor_course GET    /tutor_courses/:id(.:format)               tutor_courses#show
#                            PATCH  /tutor_courses/:id(.:format)               tutor_courses#update
#                            PUT    /tutor_courses/:id(.:format)               tutor_courses#update
#                            DELETE /tutor_courses/:id(.:format)               tutor_courses#destroy
#        dashboard_home_user GET    /:id/dashboard/home(.:format)              dashboard#home
#    dashboard_schedule_user GET    /:id/dashboard/schedule(.:format)          dashboard#schedule
#     dashboard_courses_user GET    /:id/dashboard/courses(.:format)           dashboard#courses
#     dashboard_profile_user GET    /:id/dashboard/profile(.:format)           dashboard#profile
#    dashboard_settings_user GET    /:id/dashboard/settings(.:format)          dashboard#settings
#      dashboard_tutors_user GET    /:id/dashboard/tutors(.:format)            dashboard#tutors
#                       root GET    /                                          static_pages#home
#

Rails.application.routes.draw do
  resources :tutors do
  # All of the custom routes below (except update_active_status) are necessary to allow new tutors to apply as visitors/non-signed-users while still linking their newly created Tutor to a User
  # The update_active_status is a custom route to allow Admins to activate or deactivate tutors
    member do
      put 'update_active_status'
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
  devise_for :users
  resources :courses
  resources :schools
  resources :subjects
  resources :tutor_courses

  # Still need to move:
  #===================
  # -update_transcript
  # -change_profile_pic
  # -save_profile_pic_crop

  # The custom routes below are for the dashboard which handles no logic on its own - it sends information to the respective controllers required for any operation and simply acts as a template for displaying different resources in one convenient place
  resources :users, only: [], path: '' do 
    member do       
      get  '/dashboard/home'      => 'dashboard#home'
      get  '/dashboard/schedule'  => 'dashboard#schedule'
      get  '/dashboard/courses'   => 'dashboard#courses'
      get  '/dashboard/profile'   => 'dashboard#profile'
      get  '/dashboard/settings'  => 'dashboard#settings'
      get  '/dashboard/tutors'    => 'dashboard#tutors' 
    end
  end

  root to: "static_pages#home"

end
