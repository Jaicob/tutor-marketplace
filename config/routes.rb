# == Route Map
#
#                      Prefix Verb   URI Pattern                                              Controller#Action
#                        root GET    /                                                        single_views#home
#   register_or_sign_in_tutor GET    /tutors/:id/register_or_sign_in(.:format)                tutors#register_or_sign_in
#       visitor_sign_in_tutor GET    /tutors/:id/visitor_sign_in(.:format)                    tutors#visitor_sign_in
#       visitor_sign_up_tutor GET    /tutors/:id/visitor_sign_up(.:format)                    tutors#visitor_sign_up
#       update_settings_tutor PATCH  /tutors/:id/update_settings(.:format)                    tutors#update_settings
#          visitor_new_tutors GET    /tutors/visitor_new(.:format)                            tutors#visitor_new
#       visitor_create_tutors POST   /tutors/visitor_create(.:format)                         tutors#visitor_create
#                      tutors GET    /tutors(.:format)                                        tutors#index
#                             POST   /tutors(.:format)                                        tutors#create
#                   new_tutor GET    /tutors/new(.:format)                                    tutors#new
#                  edit_tutor GET    /tutors/:id/edit(.:format)                               tutors#edit
#                       tutor GET    /tutors/:id(.:format)                                    tutors#show
#                             PATCH  /tutors/:id(.:format)                                    tutors#update
#                             PUT    /tutors/:id(.:format)                                    tutors#update
#                             DELETE /tutors/:id(.:format)                                    tutors#destroy
#            new_user_session GET    /users/sign_in(.:format)                                 devise/sessions#new
#                user_session POST   /users/sign_in(.:format)                                 devise/sessions#create
#        destroy_user_session DELETE /users/sign_out(.:format)                                devise/sessions#destroy
#               user_password POST   /users/password(.:format)                                devise/passwords#create
#           new_user_password GET    /users/password/new(.:format)                            devise/passwords#new
#          edit_user_password GET    /users/password/edit(.:format)                           devise/passwords#edit
#                             PATCH  /users/password(.:format)                                devise/passwords#update
#                             PUT    /users/password(.:format)                                devise/passwords#update
#    cancel_user_registration GET    /users/cancel(.:format)                                  devise_invitable/registrations#cancel
#           user_registration POST   /users(.:format)                                         devise_invitable/registrations#create
#       new_user_registration GET    /users/sign_up(.:format)                                 devise_invitable/registrations#new
#      edit_user_registration GET    /users/edit(.:format)                                    devise_invitable/registrations#edit
#                             PATCH  /users(.:format)                                         devise_invitable/registrations#update
#                             PUT    /users(.:format)                                         devise_invitable/registrations#update
#                             DELETE /users(.:format)                                         devise_invitable/registrations#destroy
#           user_confirmation POST   /users/confirmation(.:format)                            devise/confirmations#create
#       new_user_confirmation GET    /users/confirmation/new(.:format)                        devise/confirmations#new
#                             GET    /users/confirmation(.:format)                            devise/confirmations#show
#      accept_user_invitation GET    /users/invitation/accept(.:format)                       devise/invitations#edit
#      remove_user_invitation GET    /users/invitation/remove(.:format)                       devise/invitations#destroy
#             user_invitation POST   /users/invitation(.:format)                              devise/invitations#create
#         new_user_invitation GET    /users/invitation/new(.:format)                          devise/invitations#new
#                             PATCH  /users/invitation(.:format)                              devise/invitations#update
#                             PUT    /users/invitation(.:format)                              devise/invitations#update
#               tutor_courses GET    /tutor_courses(.:format)                                 tutor_courses#index
#                             POST   /tutor_courses(.:format)                                 tutor_courses#create
#            new_tutor_course GET    /tutor_courses/new(.:format)                             tutor_courses#new
#           edit_tutor_course GET    /tutor_courses/:id/edit(.:format)                        tutor_courses#edit
#                tutor_course GET    /tutor_courses/:id(.:format)                             tutor_courses#show
#                             PATCH  /tutor_courses/:id(.:format)                             tutor_courses#update
#                             PUT    /tutor_courses/:id(.:format)                             tutor_courses#update
#                             DELETE /tutor_courses/:id(.:format)                             tutor_courses#destroy
#                       slots GET    /slots(.:format)                                         slots#index
#                             POST   /slots(.:format)                                         slots#create
#                    new_slot GET    /slots/new(.:format)                                     slots#new
#                   edit_slot GET    /slots/:id/edit(.:format)                                slots#edit
#                        slot GET    /slots/:id(.:format)                                     slots#show
#                             PATCH  /slots/:id(.:format)                                     slots#update
#                             PUT    /slots/:id(.:format)                                     slots#update
#                             DELETE /slots/:id(.:format)                                     slots#destroy
#                      search GET    /search(.:format)                                        single_views#tutor_search
#         dashboard_home_user GET    /:id/dashboard/home(.:format)                            dashboard/home#index
#     dashboard_schedule_user GET    /:id/dashboard/schedule(.:format)                        dashboard/schedule#index
#      dashboard_courses_user GET    /:id/dashboard/courses(.:format)                         dashboard/courses#index
#      dashboard_profile_user GET    /:id/dashboard/profile(.:format)                         dashboard/profile#index
# dashboard_edit_profile_user GET    /:id/dashboard/edit_profile(.:format)                    dashboard/profile#edit
#     dashboard_settings_user GET    /:id/dashboard/settings(.:format)                        dashboard/settings#index
#       dashboard_tutors_user GET    /:id/dashboard/tutors(.:format)                          dashboard/tutors#index
#                        user PATCH  /:id(.:format)                                           users#update
#                             PUT    /:id(.:format)                                           users#update
#              school_courses GET    /campus_admin/:school_id/courses(.:format)               admin/courses#index
#                             POST   /campus_admin/:school_id/courses(.:format)               admin/courses#create
#           new_school_course GET    /campus_admin/:school_id/courses/new(.:format)           admin/courses#new
#          edit_school_course GET    /campus_admin/:school_id/courses/:id/edit(.:format)      admin/courses#edit
#               school_course GET    /campus_admin/:school_id/courses/:id(.:format)           admin/courses#show
#                             PATCH  /campus_admin/:school_id/courses/:id(.:format)           admin/courses#update
#                             PUT    /campus_admin/:school_id/courses/:id(.:format)           admin/courses#update
#                             DELETE /campus_admin/:school_id/courses/:id(.:format)           admin/courses#destroy
#               school_tutors GET    /campus_admin/:school_id/tutors(.:format)                admin/tutors#index
#                             POST   /campus_admin/:school_id/tutors(.:format)                admin/tutors#create
#            new_school_tutor GET    /campus_admin/:school_id/tutors/new(.:format)            admin/tutors#new
#           edit_school_tutor GET    /campus_admin/:school_id/tutors/:id/edit(.:format)       admin/tutors#edit
#                school_tutor GET    /campus_admin/:school_id/tutors/:id(.:format)            admin/tutors#show
#                             PATCH  /campus_admin/:school_id/tutors/:id(.:format)            admin/tutors#update
#                             PUT    /campus_admin/:school_id/tutors/:id(.:format)            admin/tutors#update
#                             DELETE /campus_admin/:school_id/tutors/:id(.:format)            admin/tutors#destroy
#             school_students GET    /campus_admin/:school_id/students(.:format)              admin/students#index
#                             POST   /campus_admin/:school_id/students(.:format)              admin/students#create
#          new_school_student GET    /campus_admin/:school_id/students/new(.:format)          admin/students#new
#         edit_school_student GET    /campus_admin/:school_id/students/:id/edit(.:format)     admin/students#edit
#              school_student GET    /campus_admin/:school_id/students/:id(.:format)          admin/students#show
#                             PATCH  /campus_admin/:school_id/students/:id(.:format)          admin/students#update
#                             PUT    /campus_admin/:school_id/students/:id(.:format)          admin/students#update
#                             DELETE /campus_admin/:school_id/students/:id(.:format)          admin/students#destroy
#         school_appointments GET    /campus_admin/:school_id/appointments(.:format)          admin/appointments#index
#                             POST   /campus_admin/:school_id/appointments(.:format)          admin/appointments#create
#      new_school_appointment GET    /campus_admin/:school_id/appointments/new(.:format)      admin/appointments#new
#     edit_school_appointment GET    /campus_admin/:school_id/appointments/:id/edit(.:format) admin/appointments#edit
#          school_appointment GET    /campus_admin/:school_id/appointments/:id(.:format)      admin/appointments#show
#                             PATCH  /campus_admin/:school_id/appointments/:id(.:format)      admin/appointments#update
#                             PUT    /campus_admin/:school_id/appointments/:id(.:format)      admin/appointments#update
#                             DELETE /campus_admin/:school_id/appointments/:id(.:format)      admin/appointments#destroy
#                school_slots GET    /campus_admin/:school_id/slots(.:format)                 admin/slots#index
#                             POST   /campus_admin/:school_id/slots(.:format)                 admin/slots#create
#             new_school_slot GET    /campus_admin/:school_id/slots/new(.:format)             admin/slots#new
#            edit_school_slot GET    /campus_admin/:school_id/slots/:id/edit(.:format)        admin/slots#edit
#                 school_slot GET    /campus_admin/:school_id/slots/:id(.:format)             admin/slots#show
#                             PATCH  /campus_admin/:school_id/slots/:id(.:format)             admin/slots#update
#                             PUT    /campus_admin/:school_id/slots/:id(.:format)             admin/slots#update
#                             DELETE /campus_admin/:school_id/slots/:id(.:format)             admin/slots#destroy
#                 school_home GET    /campus_admin/:school_id/home(.:format)                  admin/home#index
#               admin_courses GET    /admin/courses(.:format)                                 admin/courses#index
#                             POST   /admin/courses(.:format)                                 admin/courses#create
#            new_admin_course GET    /admin/courses/new(.:format)                             admin/courses#new
#           edit_admin_course GET    /admin/courses/:id/edit(.:format)                        admin/courses#edit
#                admin_course GET    /admin/courses/:id(.:format)                             admin/courses#show
#                             PATCH  /admin/courses/:id(.:format)                             admin/courses#update
#                             PUT    /admin/courses/:id(.:format)                             admin/courses#update
#                             DELETE /admin/courses/:id(.:format)                             admin/courses#destroy
#                admin_tutors GET    /admin/tutors(.:format)                                  admin/tutors#index
#                             POST   /admin/tutors(.:format)                                  admin/tutors#create
#             new_admin_tutor GET    /admin/tutors/new(.:format)                              admin/tutors#new
#            edit_admin_tutor GET    /admin/tutors/:id/edit(.:format)                         admin/tutors#edit
#                 admin_tutor GET    /admin/tutors/:id(.:format)                              admin/tutors#show
#                             PATCH  /admin/tutors/:id(.:format)                              admin/tutors#update
#                             PUT    /admin/tutors/:id(.:format)                              admin/tutors#update
#                             DELETE /admin/tutors/:id(.:format)                              admin/tutors#destroy
#              admin_students GET    /admin/students(.:format)                                admin/students#index
#                             POST   /admin/students(.:format)                                admin/students#create
#           new_admin_student GET    /admin/students/new(.:format)                            admin/students#new
#          edit_admin_student GET    /admin/students/:id/edit(.:format)                       admin/students#edit
#               admin_student GET    /admin/students/:id(.:format)                            admin/students#show
#                             PATCH  /admin/students/:id(.:format)                            admin/students#update
#                             PUT    /admin/students/:id(.:format)                            admin/students#update
#                             DELETE /admin/students/:id(.:format)                            admin/students#destroy
#          admin_appointments GET    /admin/appointments(.:format)                            admin/appointments#index
#                             POST   /admin/appointments(.:format)                            admin/appointments#create
#       new_admin_appointment GET    /admin/appointments/new(.:format)                        admin/appointments#new
#      edit_admin_appointment GET    /admin/appointments/:id/edit(.:format)                   admin/appointments#edit
#           admin_appointment GET    /admin/appointments/:id(.:format)                        admin/appointments#show
#                             PATCH  /admin/appointments/:id(.:format)                        admin/appointments#update
#                             PUT    /admin/appointments/:id(.:format)                        admin/appointments#update
#                             DELETE /admin/appointments/:id(.:format)                        admin/appointments#destroy
#                 admin_slots GET    /admin/slots(.:format)                                   admin/slots#index
#                             POST   /admin/slots(.:format)                                   admin/slots#create
#              new_admin_slot GET    /admin/slots/new(.:format)                               admin/slots#new
#             edit_admin_slot GET    /admin/slots/:id/edit(.:format)                          admin/slots#edit
#                  admin_slot GET    /admin/slots/:id(.:format)                               admin/slots#show
#                             PATCH  /admin/slots/:id(.:format)                               admin/slots#update
#                             PUT    /admin/slots/:id(.:format)                               admin/slots#update
#                             DELETE /admin/slots/:id(.:format)                               admin/slots#destroy
#               admin_schools GET    /admin/schools(.:format)                                 admin/schools#index
#                             POST   /admin/schools(.:format)                                 admin/schools#create
#            new_admin_school GET    /admin/schools/new(.:format)                             admin/schools#new
#           edit_admin_school GET    /admin/schools/:id/edit(.:format)                        admin/schools#edit
#                admin_school GET    /admin/schools/:id(.:format)                             admin/schools#show
#                             PATCH  /admin/schools/:id(.:format)                             admin/schools#update
#                             PUT    /admin/schools/:id(.:format)                             admin/schools#update
#                             DELETE /admin/schools/:id(.:format)                             admin/schools#destroy
#                  admin_home GET    /admin/home(.:format)                                    admin/home#index
#                         api        /                                                        API
#                 sidekiq_web        /sidekiq                                                 Sidekiq::Web
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

  # # The following routes are for campus managers with access to only one school
  # scope '/campus-admin' do
  #   scope module: :admin do 
  #     resources :schools, only: [], path: '' do 
  #       resources :courses
  #       resources :tutors
  #       resources :students
  #       resources :appointments
  #       resources :slots
  #       get 'home'   => 'home#index'
  #     end
  #   end
  # end

  # The following routes are for super_admin with access to all records across all schools
  namespace :campus_manager do
    resources :schools, only: [], path: '' do
      resources :courses
      resources :tutors
      resources :students
      resources :appointments do
        collection do
          match 'search' => 'appointments#search', via: [:get, :post], as: :search
        end
      end
      resources :slots
      get 'home'   => 'home#index'
    end
  end

  # The following routes are for super_admin with access to all records across all schools
  namespace :admin do
    resources :courses
    resources :tutors
    resources :students
    resources :appointments do
      collection do
        match 'search' => 'appointments#search', via: [:get, :post], as: :search
      end
    end
    resources :slots
    resources :schools
    get 'home'   => 'home#index'
  end

  mount API => '/'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
