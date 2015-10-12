# == Route Map
#
#                                Prefix Verb     URI Pattern                                                        Controller#Action
#                                  root GET      /                                                                  single_views#home
#                                search GET      /search(.:format)                                                  single_views#tutor_search
#                     restricted_access GET      /restricted-access(.:format)                                       single_views#restricted_access
#                                 about GET      /about(.:format)                                                   single_views#about
#                                  faqs GET      /faqs(.:format)                                                    single_views#faqs
#                              partners GET      /partners(.:format)                                                single_views#partners
#                        become_a_tutor GET      /become-a-tutor(.:format)                                          single_views#tutor_landing
#                               contact GET      /contact(.:format)                                                 single_views#contact
#                        privacy_policy GET      /privacy-policy(.:format)                                          single_views#privacy_policy
#                  terms_and_conditions GET      /terms-and-conditions(.:format)                                    single_views#terms_and_conditions
#                            set_school POST     /set-school(.:format)                                              cookies#set_school_id_cookie
#                      new_user_session GET      /users/sign_in(.:format)                                           devise/sessions#new
#                          user_session POST     /users/sign_in(.:format)                                           devise/sessions#create
#                  destroy_user_session DELETE   /users/sign_out(.:format)                                          devise/sessions#destroy
#                         user_password POST     /users/password(.:format)                                          devise/passwords#create
#                     new_user_password GET      /users/password/new(.:format)                                      devise/passwords#new
#                    edit_user_password GET      /users/password/edit(.:format)                                     devise/passwords#edit
#                                       PATCH    /users/password(.:format)                                          devise/passwords#update
#                                       PUT      /users/password(.:format)                                          devise/passwords#update
#              cancel_user_registration GET      /users/cancel(.:format)                                            tutor_registration#cancel
#                     user_registration POST     /users(.:format)                                                   tutor_registration#create
#                 new_user_registration GET      /users/sign_up(.:format)                                           tutor_registration#new
#                edit_user_registration GET      /users/edit(.:format)                                              tutor_registration#edit
#                                       PATCH    /users(.:format)                                                   tutor_registration#update
#                                       PUT      /users(.:format)                                                   tutor_registration#update
#                                       DELETE   /users(.:format)                                                   tutor_registration#destroy
#                     user_confirmation POST     /users/confirmation(.:format)                                      devise/confirmations#create
#                 new_user_confirmation GET      /users/confirmation/new(.:format)                                  devise/confirmations#new
#                                       GET      /users/confirmation(.:format)                                      devise/confirmations#show
#                accept_user_invitation GET      /users/invitation/accept(.:format)                                 devise/invitations#edit
#                remove_user_invitation GET      /users/invitation/remove(.:format)                                 devise/invitations#destroy
#                       user_invitation POST     /users/invitation(.:format)                                        devise/invitations#create
#                   new_user_invitation GET      /users/invitation/new(.:format)                                    devise/invitations#new
#                                       PATCH    /users/invitation(.:format)                                        devise/invitations#update
#                                       PUT      /users/invitation(.:format)                                        devise/invitations#update
#                                 slots GET      /slots(.:format)                                                   slots#index
#                                       POST     /slots(.:format)                                                   slots#create
#                              new_slot GET      /slots/new(.:format)                                               slots#new
#                             edit_slot GET      /slots/:id/edit(.:format)                                          slots#edit
#                                  slot GET      /slots/:id(.:format)                                               slots#show
#                                       PATCH    /slots/:id(.:format)                                               slots#update
#                                       PUT      /slots/:id(.:format)                                               slots#update
#                                       DELETE   /slots/:id(.:format)                                               slots#destroy
#         tutor_payment_info_form_tutor GET      /tutors/:id/tutor_payment_info_form(.:format)                      tutors#tutor_payment_info_form
#       update_tutor_payment_info_tutor PATCH    /tutors/:id/update_tutor_payment_info(.:format)                    tutors#update_tutor_payment_info
#                                tutors GET      /tutors(.:format)                                                  tutors#index
#                                       POST     /tutors(.:format)                                                  tutors#create
#                             new_tutor GET      /tutors/new(.:format)                                              tutors#new
#                            edit_tutor GET      /tutors/:id/edit(.:format)                                         tutors#edit
#                                 tutor GET      /tutors/:id(.:format)                                              tutors#show
#                                       PATCH    /tutors/:id(.:format)                                              tutors#update
#                                       PUT      /tutors/:id(.:format)                                              tutors#update
#                                       DELETE   /tutors/:id(.:format)                                              tutors#destroy
#                            home_tutor GET      /:id/home(.:format)                                                dashboard/tutor/home#index
#                        schedule_tutor GET      /:id/schedule(.:format)                                            dashboard/tutor/schedule#index
#                         profile_tutor GET      /:id/profile(.:format)                                             dashboard/tutor/profile#index
#                    edit_profile_tutor GET      /:id/edit_profile(.:format)                                        dashboard/tutor/profile#edit
#                         account_tutor GET      /:id/settings/account(.:format)                                    dashboard/tutor/settings#account
#                    private_info_tutor GET      /:id/settings/private_info(.:format)                               dashboard/tutor/settings#private_info
#                                       GET      /:id/settings/profile(.:format)                                    dashboard/tutor/settings#profile
#                    appointments_tutor GET      /:id/settings/appointments(.:format)                               dashboard/tutor/settings#appointment_settings
#                   tutor_payment_tutor GET      /:id/settings/tutor_payment(.:format)                              dashboard/tutor/settings#tutor_payment
#      tutor_payment_edit_address_tutor GET      /:id/settings/tutor_payment_edit_address(.:format)                 dashboard/tutor/settings#edit_tutor_payment_address
#                 student_payment_tutor GET      /:id/settings/student_payment(.:format)                            dashboard/tutor/settings#student_payment
#             appointment_history_tutor GET      /:id/settings/appointment_history(.:format)                        dashboard/tutor/settings#appointment_history
#                         tutor_courses GET      /:tutor_id/courses(.:format)                                       dashboard/tutor/courses#index
#                                       POST     /:tutor_id/courses(.:format)                                       dashboard/tutor/courses#create
#                      new_tutor_course GET      /:tutor_id/courses/new(.:format)                                   dashboard/tutor/courses#new
#                     edit_tutor_course GET      /:tutor_id/courses/:id/edit(.:format)                              dashboard/tutor/courses#edit
#                          tutor_course GET      /:tutor_id/courses/:id(.:format)                                   dashboard/tutor/courses#show
#                                       PATCH    /:tutor_id/courses/:id(.:format)                                   dashboard/tutor/courses#update
#                                       PUT      /:tutor_id/courses/:id(.:format)                                   dashboard/tutor/courses#update
#                                       DELETE   /:tutor_id/courses/:id(.:format)                                   dashboard/tutor/courses#destroy
#                      tutor_promotions GET      /:tutor_id/promotions(.:format)                                    dashboard/tutor/promotions#index
#                                       POST     /:tutor_id/promotions(.:format)                                    dashboard/tutor/promotions#create
#                   new_tutor_promotion GET      /:tutor_id/promotions/new(.:format)                                dashboard/tutor/promotions#new
#                  edit_tutor_promotion GET      /:tutor_id/promotions/:id/edit(.:format)                           dashboard/tutor/promotions#edit
#                       tutor_promotion GET      /:tutor_id/promotions/:id(.:format)                                dashboard/tutor/promotions#show
#                                       PATCH    /:tutor_id/promotions/:id(.:format)                                dashboard/tutor/promotions#update
#                                       PUT      /:tutor_id/promotions/:id(.:format)                                dashboard/tutor/promotions#update
#                                       DELETE   /:tutor_id/promotions/:id(.:format)                                dashboard/tutor/promotions#destroy
#                                       PATCH    /:id(.:format)                                                     users#update
#                                       PUT      /:id(.:format)                                                     users#update
#                          home_student GET      /:id/home(.:format)                                                dashboard/student/home#index
#                        search_student GET      /:id/search(.:format)                                              single_views#tutor_search
#               student_payment_student GET      /:id/settings/student_payment(.:format)                            dashboard/student/settings#student_payment
#           appointment_history_student GET      /:id/settings/appointment_history(.:format)                        dashboard/student/settings#appointment_history
#                               student PATCH    /:id(.:format)                                                     users#update
#                                       PUT      /:id(.:format)                                                     users#update
#                  search_admin_courses GET|POST /admin/courses/search(.:format)                                    admin/courses#search
#         new_course_list_admin_courses POST     /admin/courses/new_course_list(.:format)                           admin/courses#new_course_list
#  review_new_course_list_admin_courses POST     /admin/courses/review_new_course_list(.:format)                    admin/courses#review_new_course_list
#  create_new_course_list_admin_courses POST     /admin/courses/create_new_course_list(.:format)                    admin/courses#create_new_course_list
#                         admin_courses GET      /admin/courses(.:format)                                           admin/courses#index
#                                       POST     /admin/courses(.:format)                                           admin/courses#create
#                      new_admin_course GET      /admin/courses/new(.:format)                                       admin/courses#new
#                     edit_admin_course GET      /admin/courses/:id/edit(.:format)                                  admin/courses#edit
#                          admin_course GET      /admin/courses/:id(.:format)                                       admin/courses#show
#                                       PATCH    /admin/courses/:id(.:format)                                       admin/courses#update
#                                       PUT      /admin/courses/:id(.:format)                                       admin/courses#update
#                                       DELETE   /admin/courses/:id(.:format)                                       admin/courses#destroy
#                   search_admin_tutors GET|POST /admin/tutors/search(.:format)                                     admin/tutors#search
#                          admin_tutors GET      /admin/tutors(.:format)                                            admin/tutors#index
#                                       POST     /admin/tutors(.:format)                                            admin/tutors#create
#                       new_admin_tutor GET      /admin/tutors/new(.:format)                                        admin/tutors#new
#                      edit_admin_tutor GET      /admin/tutors/:id/edit(.:format)                                   admin/tutors#edit
#                           admin_tutor GET      /admin/tutors/:id(.:format)                                        admin/tutors#show
#                                       PATCH    /admin/tutors/:id(.:format)                                        admin/tutors#update
#                                       PUT      /admin/tutors/:id(.:format)                                        admin/tutors#update
#                                       DELETE   /admin/tutors/:id(.:format)                                        admin/tutors#destroy
#                 search_admin_students GET|POST /admin/students/search(.:format)                                   admin/students#search
#                        admin_students GET      /admin/students(.:format)                                          admin/students#index
#                                       POST     /admin/students(.:format)                                          admin/students#create
#                     new_admin_student GET      /admin/students/new(.:format)                                      admin/students#new
#                    edit_admin_student GET      /admin/students/:id/edit(.:format)                                 admin/students#edit
#                         admin_student GET      /admin/students/:id(.:format)                                      admin/students#show
#                                       PATCH    /admin/students/:id(.:format)                                      admin/students#update
#                                       PUT      /admin/students/:id(.:format)                                      admin/students#update
#                                       DELETE   /admin/students/:id(.:format)                                      admin/students#destroy
#             search_admin_appointments GET|POST /admin/appointments/search(.:format)                               admin/appointments#search
#                    admin_appointments GET      /admin/appointments(.:format)                                      admin/appointments#index
#                                       POST     /admin/appointments(.:format)                                      admin/appointments#create
#                 new_admin_appointment GET      /admin/appointments/new(.:format)                                  admin/appointments#new
#                edit_admin_appointment GET      /admin/appointments/:id/edit(.:format)                             admin/appointments#edit
#                     admin_appointment GET      /admin/appointments/:id(.:format)                                  admin/appointments#show
#                                       PATCH    /admin/appointments/:id(.:format)                                  admin/appointments#update
#                                       PUT      /admin/appointments/:id(.:format)                                  admin/appointments#update
#                                       DELETE   /admin/appointments/:id(.:format)                                  admin/appointments#destroy
#                    search_admin_slots GET|POST /admin/slots/search(.:format)                                      admin/slots#search
#                           admin_slots GET      /admin/slots(.:format)                                             admin/slots#index
#                                       POST     /admin/slots(.:format)                                             admin/slots#create
#                        new_admin_slot GET      /admin/slots/new(.:format)                                         admin/slots#new
#                       edit_admin_slot GET      /admin/slots/:id/edit(.:format)                                    admin/slots#edit
#                            admin_slot GET      /admin/slots/:id(.:format)                                         admin/slots#show
#                                       PATCH    /admin/slots/:id(.:format)                                         admin/slots#update
#                                       PUT      /admin/slots/:id(.:format)                                         admin/slots#update
#                                       DELETE   /admin/slots/:id(.:format)                                         admin/slots#destroy
#                  search_admin_schools GET|POST /admin/schools/search(.:format)                                    admin/schools#search
#                         admin_schools GET      /admin/schools(.:format)                                           admin/schools#index
#                                       POST     /admin/schools(.:format)                                           admin/schools#create
#                      new_admin_school GET      /admin/schools/new(.:format)                                       admin/schools#new
#                     edit_admin_school GET      /admin/schools/:id/edit(.:format)                                  admin/schools#edit
#                          admin_school GET      /admin/schools/:id(.:format)                                       admin/schools#show
#                                       PATCH    /admin/schools/:id(.:format)                                       admin/schools#update
#                                       PUT      /admin/schools/:id(.:format)                                       admin/schools#update
#                                       DELETE   /admin/schools/:id(.:format)                                       admin/schools#destroy
#               search_admin_promotions GET|POST /admin/promotions/search(.:format)                                 admin/promotions#search
#                      admin_promotions GET      /admin/promotions(.:format)                                        admin/promotions#index
#                                       POST     /admin/promotions(.:format)                                        admin/promotions#create
#                   new_admin_promotion GET      /admin/promotions/new(.:format)                                    admin/promotions#new
#                  edit_admin_promotion GET      /admin/promotions/:id/edit(.:format)                               admin/promotions#edit
#                       admin_promotion GET      /admin/promotions/:id(.:format)                                    admin/promotions#show
#                                       PATCH    /admin/promotions/:id(.:format)                                    admin/promotions#update
#                                       PUT      /admin/promotions/:id(.:format)                                    admin/promotions#update
#                                       DELETE   /admin/promotions/:id(.:format)                                    admin/promotions#destroy
#         api_v1_school_subject_courses GET      /api/v1/schools/:school_id/subjects/:subject_id/courses(.:format)  api/v1/courses#index {:format=>:json}
#                api_v1_school_subjects GET      /api/v1/schools/:school_id/subjects(.:format)                      api/v1/subjects#index {:format=>:json}
#                    api_v1_tutor_slots GET      /api/v1/tutors/:tutor_id/slots(.:format)                           api/v1/slots#index {:format=>:json}
#                                       POST     /api/v1/tutors/:tutor_id/slots(.:format)                           api/v1/slots#create {:format=>:json}
#                     api_v1_tutor_slot GET      /api/v1/tutors/:tutor_id/slots/:id(.:format)                       api/v1/slots#show {:format=>:json}
#                                       DELETE   /api/v1/tutors/:tutor_id/slots/:id(.:format)                       api/v1/slots#destroy {:format=>:json}
#             api_v1_tutor_slots_update POST     /api/v1/tutors/:tutor_id/slots/update(.:format)                    api/v1/slots#update_slots {:format=>:json}
#                  api_v1_tutor_courses GET      /api/v1/tutors/:tutor_id/courses(.:format)                         api/v1/tutor_courses#index {:format=>:json}
#       cancel_api_v1_tutor_appointment PUT      /api/v1/tutors/:tutor_id/appointments/:id/cancel(.:format)         api/v1/tutor_appointments#cancel {:format=>:json}
#             api_v1_tutor_appointments GET      /api/v1/tutors/:tutor_id/appointments(.:format)                    api/v1/tutor_appointments#index {:format=>:json}
#              api_v1_tutor_appointment GET      /api/v1/tutors/:tutor_id/appointments/:id(.:format)                api/v1/tutor_appointments#show {:format=>:json}
# reschedule_api_v1_student_appointment PUT      /api/v1/students/:student_id/appointments/:id/reschedule(.:format) api/v1/student_appointments#reschedule {:format=>:json}
#     cancel_api_v1_student_appointment PUT      /api/v1/students/:student_id/appointments/:id/cancel(.:format)     api/v1/student_appointments#cancel {:format=>:json}
#           api_v1_student_appointments GET      /api/v1/students/:student_id/appointments(.:format)                api/v1/student_appointments#index {:format=>:json}
#                                       POST     /api/v1/students/:student_id/appointments(.:format)                api/v1/student_appointments#create {:format=>:json}
#            api_v1_student_appointment GET      /api/v1/students/:student_id/appointments/:id(.:format)            api/v1/student_appointments#show {:format=>:json}
#                  api_v1_search_tutors GET      /api/v1/search/tutors(.:format)                                    api/v1/search#tutors {:format=>:json}
#                           sidekiq_web          /sidekiq                                                           Sidekiq::Web
#


Rails.application.routes.draw do

  # home_page
  root                         'single_views#home'

  # single_view_pages
  get '/search'               => 'single_views#tutor_search'
  get '/restricted-access'    => 'single_views#restricted_access'
  get '/about'                => 'single_views#about'
  get '/faqs'                 => 'single_views#faqs'
  get '/partners'             => 'single_views#partners'
  get '/become-a-tutor'       => 'single_views#tutor_landing'
  get '/contact'              => 'single_views#contact'
  get '/privacy-policy'       => 'single_views#privacy_policy'
  get '/terms-and-conditions' => 'single_views#terms_and_conditions'
  post '/set-school'          => 'cookies#set_school_id_cookie'

  # custom_devise_routes
  devise_for :users, controllers: { registrations: "tutor_registration" }

  # standard resources for slots
  resources :slots

  # user endpoints for update and destroy 
  resources :users, only: [:update, :destroy]

  resources :tutors do
    member do
              get '/tutor_payment_info_form'       => 'tutors#tutor_payment_info_form', as: 'tutor_payment_info_form'
        patch '/update_tutor_payment_info'   => 'tutors#update_tutor_payment_info', as: 'update_tutor_payment_info'
    end
  end

  # all dashboard routes for signed-in tutors
  resources :tutors, only: [:update, :destroy] do
    member do
      get  '/home'                        => 'dashboard/tutor/home#index'
      get  '/schedule'                    => 'dashboard/tutor/schedule#index'
      get  '/profile'                     => 'dashboard/tutor/profile#index'
      scope 'settings' do 
        get  '/account'                     => 'dashboard/tutor/settings#account'
        get  '/private_info'                => 'dashboard/tutor/settings#private_info'
        get  '/edit_profile'                => 'dashboard/tutor/settings#edit_profile'
        get  '/appointment_settings'        => 'dashboard/tutor/settings#appointment_settings' 
        get  '/payment_info'                => 'dashboard/tutor/settings#tutor_payment'
        get  '/edit_address_info'           => 'dashboard/tutor/settings#edit_tutor_payment_address'
        get  '/appointment_history'         => 'dashboard/tutor/settings#appointment_history'
      end
    end
    resources :courses, controller: 'dashboard/tutor/courses'
    resources :promotions, controller: 'dashboard/tutor/promotions'
  end

  # all dashboard routes for signed-in students
  resources :students, only: [:update, :destroy] do 
    member do 
      get  '/home'                 => 'dashboard/student/home#index'
      get  '/search'               => 'single_views#tutor_search'      
      scope 'settings' do
        get  '/account'               => 'dashboard/student/settings#account'
        get  '/student_payment'       => 'dashboard/student/settings#student_payment'
        get  '/appointment_history'   => 'dashboard/student/settings#appointment_history'
      end
    end
  end

  # restricted admin-only area routes (the collections after the resources are for ransack search)
  namespace :admin do
    resources :courses do
      collection do
        match 'search' => 'courses#search', via: [:get, :post], as: :search
        post 'new_course_list' => 'courses#new_course_list'
        post 'review_new_course_list' => 'courses#review_new_course_list'
        post 'create_new_course_list' => 'courses#create_new_course_list'
      end
    end
    resources :tutors do collection { match 'search' => 'tutors#search', via: [:get, :post], as: :search } end
    resources :students do collection { match 'search' => 'students#search', via: [:get, :post], as: :search } end
    resources :appointments do collection { match 'search' => 'appointments#search', via: [:get, :post], as: :search } end
    resources :slots do collection { match 'search' => 'slots#search', via: [:get, :post], as: :search } end
    resources :schools do collection { match 'search' => 'schools#search', via: [:get, :post], as: :search } end
    resources :promotions do collection { match 'search' => 'promotions#search', via: [:get, :post], as: :search } end
  end

  # API routes
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :schools, only: [] do
        resources :subjects, only: [:index] do
          resources :courses, only: [:index]
        end
      end
      resources :tutors, only: [] do
        resources :slots, only: [:index, :show, :create, :destroy]
        post '/slots/update' => 'slots#update_slots'
        get '/courses' => 'tutor_courses#index'
        resources :appointments, only: [:index, :show], controller: 'tutor_appointments' do 
          member do
            put 'cancel'
          end
        end
      end
      resources :students, only: [] do
        resources :appointments, only: [:index, :show, :create], controller: 'student_appointments' do
          member do
            put 'reschedule'
            put 'cancel'
          end
        end
      end
      get '/search/tutors' => 'search#tutors'
    end
  end

  # routes for Sidekiq background processes
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
