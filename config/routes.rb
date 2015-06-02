# == Route Map
#
#                   Prefix Verb   URI Pattern                        Controller#Action
#            courses_tutor GET    /tutors/:id/courses(.:format)      tutors#courses
#                          PUT    /tutors/:id/courses(.:format)      tutors#courses
#                   tutors GET    /tutors(.:format)                  tutors#index
#                          POST   /tutors(.:format)                  tutors#create
#                new_tutor GET    /tutors/new(.:format)              tutors#new
#               edit_tutor GET    /tutors/:id/edit(.:format)         tutors#edit
#                    tutor GET    /tutors/:id(.:format)              tutors#show
#                          PATCH  /tutors/:id(.:format)              tutors#update
#                          PUT    /tutors/:id(.:format)              tutors#update
#                          DELETE /tutors/:id(.:format)              tutors#destroy
#                  courses GET    /courses(.:format)                 courses#index
#                          POST   /courses(.:format)                 courses#create
#               new_course GET    /courses/new(.:format)             courses#new
#              edit_course GET    /courses/:id/edit(.:format)        courses#edit
#                   course GET    /courses/:id(.:format)             courses#show
#                          PATCH  /courses/:id(.:format)             courses#update
#                          PUT    /courses/:id(.:format)             courses#update
#                          DELETE /courses/:id(.:format)             courses#destroy
#                 subjects GET    /subjects(.:format)                subjects#index
#                          POST   /subjects(.:format)                subjects#create
#              new_subject GET    /subjects/new(.:format)            subjects#new
#             edit_subject GET    /subjects/:id/edit(.:format)       subjects#edit
#                  subject GET    /subjects/:id(.:format)            subjects#show
#                          PATCH  /subjects/:id(.:format)            subjects#update
#                          PUT    /subjects/:id(.:format)            subjects#update
#                          DELETE /subjects/:id(.:format)            subjects#destroy
#                  schools GET    /schools(.:format)                 schools#index
#                          POST   /schools(.:format)                 schools#create
#               new_school GET    /schools/new(.:format)             schools#new
#              edit_school GET    /schools/:id/edit(.:format)        schools#edit
#                   school GET    /schools/:id(.:format)             schools#show
#                          PATCH  /schools/:id(.:format)             schools#update
#                          PUT    /schools/:id(.:format)             schools#update
#                          DELETE /schools/:id(.:format)             schools#destroy
#         new_user_session GET    /users/sign_in(.:format)           devise/sessions#new
#             user_session POST   /users/sign_in(.:format)           devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)          devise/sessions#destroy
#            user_password POST   /users/password(.:format)          devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)      devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)     devise/passwords#edit
#                          PATCH  /users/password(.:format)          devise/passwords#update
#                          PUT    /users/password(.:format)          devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)            devise_invitable/registrations#cancel
#        user_registration POST   /users(.:format)                   devise_invitable/registrations#create
#    new_user_registration GET    /users/sign_up(.:format)           devise_invitable/registrations#new
#   edit_user_registration GET    /users/edit(.:format)              devise_invitable/registrations#edit
#                          PATCH  /users(.:format)                   devise_invitable/registrations#update
#                          PUT    /users(.:format)                   devise_invitable/registrations#update
#                          DELETE /users(.:format)                   devise_invitable/registrations#destroy
#        user_confirmation POST   /users/confirmation(.:format)      devise/confirmations#create
#    new_user_confirmation GET    /users/confirmation/new(.:format)  devise/confirmations#new
#                          GET    /users/confirmation(.:format)      devise/confirmations#show
#   accept_user_invitation GET    /users/invitation/accept(.:format) devise/invitations#edit
#   remove_user_invitation GET    /users/invitation/remove(.:format) devise/invitations#destroy
#          user_invitation POST   /users/invitation(.:format)        devise/invitations#create
#      new_user_invitation GET    /users/invitation/new(.:format)    devise/invitations#new
#                          PATCH  /users/invitation(.:format)        devise/invitations#update
#                          PUT    /users/invitation(.:format)        devise/invitations#update
#                    upmin        /admin                             Upmin::Engine
#                     root GET    /                                  static_pages#home
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
  resources :tutors do 
    member do
      get 'courses'
      put 'courses'
    end
  end

  resources :courses
  resources :subjects
  resources :schools
  devise_for :users
  mount Upmin::Engine => '/admin'
  root to: "static_pages#home"
end
