# == Route Map
#
#                      Prefix Verb   URI Pattern                                Controller#Action
#   register_or_sign_in_tutor GET    /tutors/:id/register_or_sign_in(.:format)  tutors#register_or_sign_in
#       visitor_sign_in_tutor GET    /tutors/:id/visitor_sign_in(.:format)      tutors#visitor_sign_in
#       visitor_sign_up_tutor GET    /tutors/:id/visitor_sign_up(.:format)      tutors#visitor_sign_up
#  update_active_status_tutor PUT    /tutors/:id/update_active_status(.:format) tutors#update_active_status
#      destroy_by_admin_tutor DELETE /tutors/:id/destroy_by_admin(.:format)     tutors#destroy_by_admin
#       update_settings_tutor PATCH  /tutors/:id/update_settings(.:format)      tutors#update_settings
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
#               tutor_courses GET    /tutor_courses(.:format)                   tutor_courses#index
#                             POST   /tutor_courses(.:format)                   tutor_courses#create
#            new_tutor_course GET    /tutor_courses/new(.:format)               tutor_courses#new
#           edit_tutor_course GET    /tutor_courses/:id/edit(.:format)          tutor_courses#edit
#                tutor_course GET    /tutor_courses/:id(.:format)               tutor_courses#show
#                             PATCH  /tutor_courses/:id(.:format)               tutor_courses#update
#                             PUT    /tutor_courses/:id(.:format)               tutor_courses#update
#                             DELETE /tutor_courses/:id(.:format)               tutor_courses#destroy
#         home_dashboard_user GET    /:id/dashboard/home(.:format)              dashboard/home#index
#     schedule_dashboard_user GET    /:id/dashboard/schedule(.:format)          dashboard/schedule#index
#      courses_dashboard_user GET    /:id/dashboard/courses(.:format)           dashboard/courses#index
#      profile_dashboard_user GET    /:id/dashboard/profile(.:format)           dashboard/profile#index
# edit_profile_dashboard_user GET    /:id/dashboard/edit_profile(.:format)      dashboard/profile#edit
#     settings_dashboard_user GET    /:id/dashboard/settings(.:format)          dashboard/settings#index
#       tutors_dashboard_user GET    /:id/dashboard/tutors(.:format)            dashboard/tutors#index
#                        user PATCH  /:id(.:format)                             users#update
#                             PUT    /:id(.:format)                             users#update
#               admin_courses GET    /admin/courses(.:format)                   admin/courses#index
#                             POST   /admin/courses(.:format)                   admin/courses#create
#            new_admin_course GET    /admin/courses/new(.:format)               admin/courses#new
#           edit_admin_course GET    /admin/courses/:id/edit(.:format)          admin/courses#edit
#                admin_course GET    /admin/courses/:id(.:format)               admin/courses#show
#                             PATCH  /admin/courses/:id(.:format)               admin/courses#update
#                             PUT    /admin/courses/:id(.:format)               admin/courses#update
#                             DELETE /admin/courses/:id(.:format)               admin/courses#destroy
#               admin_schools GET    /admin/schools(.:format)                   admin/schools#index
#                             POST   /admin/schools(.:format)                   admin/schools#create
#            new_admin_school GET    /admin/schools/new(.:format)               admin/schools#new
#           edit_admin_school GET    /admin/schools/:id/edit(.:format)          admin/schools#edit
#                admin_school GET    /admin/schools/:id(.:format)               admin/schools#show
#                             PATCH  /admin/schools/:id(.:format)               admin/schools#update
#                             PUT    /admin/schools/:id(.:format)               admin/schools#update
#                             DELETE /admin/schools/:id(.:format)               admin/schools#destroy
#                admin_tutors GET    /admin/tutors(.:format)                    admin/tutors#index
#                             POST   /admin/tutors(.:format)                    admin/tutors#create
#             new_admin_tutor GET    /admin/tutors/new(.:format)                admin/tutors#new
#            edit_admin_tutor GET    /admin/tutors/:id/edit(.:format)           admin/tutors#edit
#                 admin_tutor GET    /admin/tutors/:id(.:format)                admin/tutors#show
#                             PATCH  /admin/tutors/:id(.:format)                admin/tutors#update
#                             PUT    /admin/tutors/:id(.:format)                admin/tutors#update
#                             DELETE /admin/tutors/:id(.:format)                admin/tutors#destroy
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

  resources :users, only: [:update], path: '' do
    member do
      namespace :dashboard do
        get  '/home'         => 'home#index'
        get  '/schedule'     => 'schedule#index'
        get  '/courses'      => 'courses#index'
        get  '/profile'      => 'profile#index'
        get  '/edit_profile' => 'profile#edit'
        get  '/settings'     => 'settings#index'
        get  '/tutors'       => 'tutors#index'
      end
    end
  end

  namespace :admin do
    resources :courses
    resources :schools
    resources :tutors
  end

  root to: "static_pages#home"

  mount API => '/'

end
