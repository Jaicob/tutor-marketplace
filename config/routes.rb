# == Route Map
#
#                                           Prefix Verb     URI Pattern                                                        Controller#Action
#                                             root GET      /                                                                  single_views#home
#                                           search GET      /search(.:format)                                                  single_views#tutor_search
#                                restricted_access GET      /restricted-access(.:format)                                       single_views#restricted_access
#                                         about_us GET      /about-us(.:format)                                                single_views#about_us
#                                             faqs GET      /faqs(.:format)                                                    single_views#faqs
#                                     partnerships GET      /partnerships(.:format)                                            single_views#partnerships
#                                   become_a_tutor GET      /become-a-tutor(.:format)                                          single_views#tutor_landing
#                                          contact GET      /contact(.:format)                                                 single_views#contact
#                                 new_user_session GET      /users/sign_in(.:format)                                           devise/sessions#new
#                                     user_session POST     /users/sign_in(.:format)                                           devise/sessions#create
#                             destroy_user_session DELETE   /users/sign_out(.:format)                                          devise/sessions#destroy
#                                    user_password POST     /users/password(.:format)                                          devise/passwords#create
#                                new_user_password GET      /users/password/new(.:format)                                      devise/passwords#new
#                               edit_user_password GET      /users/password/edit(.:format)                                     devise/passwords#edit
#                                                  PATCH    /users/password(.:format)                                          devise/passwords#update
#                                                  PUT      /users/password(.:format)                                          devise/passwords#update
#                         cancel_user_registration GET      /users/cancel(.:format)                                            tutor_registration#cancel
#                                user_registration POST     /users(.:format)                                                   tutor_registration#create
#                            new_user_registration GET      /users/sign_up(.:format)                                           tutor_registration#new
#                           edit_user_registration GET      /users/edit(.:format)                                              tutor_registration#edit
#                                                  PATCH    /users(.:format)                                                   tutor_registration#update
#                                                  PUT      /users(.:format)                                                   tutor_registration#update
#                                                  DELETE   /users(.:format)                                                   tutor_registration#destroy
#                                user_confirmation POST     /users/confirmation(.:format)                                      devise/confirmations#create
#                            new_user_confirmation GET      /users/confirmation/new(.:format)                                  devise/confirmations#new
#                                                  GET      /users/confirmation(.:format)                                      devise/confirmations#show
#                           accept_user_invitation GET      /users/invitation/accept(.:format)                                 devise/invitations#edit
#                           remove_user_invitation GET      /users/invitation/remove(.:format)                                 devise/invitations#destroy
#                                  user_invitation POST     /users/invitation(.:format)                                        devise/invitations#create
#                              new_user_invitation GET      /users/invitation/new(.:format)                                    devise/invitations#new
#                                                  PATCH    /users/invitation(.:format)                                        devise/invitations#update
#                                                  PUT      /users/invitation(.:format)                                        devise/invitations#update
#                                           tutors GET      /tutors(.:format)                                                  tutors#index
#                                                  POST     /tutors(.:format)                                                  tutors#create
#                                        new_tutor GET      /tutors/new(.:format)                                              tutors#new
#                                       edit_tutor GET      /tutors/:id/edit(.:format)                                         tutors#edit
#                                            tutor GET      /tutors/:id(.:format)                                              tutors#show
#                                                  PATCH    /tutors/:id(.:format)                                              tutors#update
#                                                  PUT      /tutors/:id(.:format)                                              tutors#update
#                                                  DELETE   /tutors/:id(.:format)                                              tutors#destroy
#                                    tutor_courses GET      /tutor_courses(.:format)                                           tutor_courses#index
#                                                  POST     /tutor_courses(.:format)                                           tutor_courses#create
#                                 new_tutor_course GET      /tutor_courses/new(.:format)                                       tutor_courses#new
#                                edit_tutor_course GET      /tutor_courses/:id/edit(.:format)                                  tutor_courses#edit
#                                     tutor_course GET      /tutor_courses/:id(.:format)                                       tutor_courses#show
#                                                  PATCH    /tutor_courses/:id(.:format)                                       tutor_courses#update
#                                                  PUT      /tutor_courses/:id(.:format)                                       tutor_courses#update
#                                                  DELETE   /tutor_courses/:id(.:format)                                       tutor_courses#destroy
#                                            slots GET      /slots(.:format)                                                   slots#index
#                                                  POST     /slots(.:format)                                                   slots#create
#                                         new_slot GET      /slots/new(.:format)                                               slots#new
#                                        edit_slot GET      /slots/:id/edit(.:format)                                          slots#edit
#                                             slot GET      /slots/:id(.:format)                                               slots#show
#                                                  PATCH    /slots/:id(.:format)                                               slots#update
#                                                  PUT      /slots/:id(.:format)                                               slots#update
#                                                  DELETE   /slots/:id(.:format)                                               slots#destroy
#                              dashboard_home_user GET      /:id/dashboard/home(.:format)                                      dashboard/home#index
#                          dashboard_schedule_user GET      /:id/dashboard/schedule(.:format)                                  dashboard/schedule#index
#                           dashboard_courses_user GET      /:id/dashboard/courses(.:format)                                   dashboard/courses#index
#                           dashboard_profile_user GET      /:id/dashboard/profile(.:format)                                   dashboard/profile#index
#                      dashboard_edit_profile_user GET      /:id/dashboard/edit_profile(.:format)                              dashboard/profile#edit
#         dashboard_settings_account_settings_user GET      /:id/dashboard/settings/account_settings(.:format)                 dashboard/settings#account_settings
#      dashboard_settings_private_information_user GET      /:id/dashboard/settings/private_information(.:format)              dashboard/settings#private_information
#         dashboard_settings_profile_settings_user GET      /:id/dashboard/settings/profile_settings(.:format)                 dashboard/settings#profile_settings
#     dashboard_settings_appointment_settings_user GET      /:id/dashboard/settings/appointment_settings(.:format)             dashboard/settings#appointment_settings
#   dashboard_settings_tutor_payment_settings_user GET      /:id/dashboard/settings/tutor_payment_settings(.:format)           dashboard/settings#tutor_payment_settings
# dashboard_settings_student_payment_settings_user GET      /:id/dashboard/settings/student_payment_settings(.:format)         dashboard/settings#student_payment_settings
#      dashboard_settings_appointment_history_user GET      /:id/dashboard/settings/appointment_history(.:format)              dashboard/settings#appointment_history
#                                             user PATCH    /:id(.:format)                                                     users#update
#                                                  PUT      /:id(.:format)                                                     users#update
#                             search_admin_courses GET|POST /admin/courses/search(.:format)                                    admin/courses#search
#                    new_course_list_admin_courses POST     /admin/courses/new_course_list(.:format)                           admin/courses#new_course_list
#             review_new_course_list_admin_courses POST     /admin/courses/review_new_course_list(.:format)                    admin/courses#review_new_course_list
#             create_new_course_list_admin_courses POST     /admin/courses/create_new_course_list(.:format)                    admin/courses#create_new_course_list
#                                    admin_courses GET      /admin/courses(.:format)                                           admin/courses#index
#                                                  POST     /admin/courses(.:format)                                           admin/courses#create
#                                 new_admin_course GET      /admin/courses/new(.:format)                                       admin/courses#new
#                                edit_admin_course GET      /admin/courses/:id/edit(.:format)                                  admin/courses#edit
#                                     admin_course GET      /admin/courses/:id(.:format)                                       admin/courses#show
#                                                  PATCH    /admin/courses/:id(.:format)                                       admin/courses#update
#                                                  PUT      /admin/courses/:id(.:format)                                       admin/courses#update
#                                                  DELETE   /admin/courses/:id(.:format)                                       admin/courses#destroy
#                              search_admin_tutors GET|POST /admin/tutors/search(.:format)                                     admin/tutors#search
#                                     admin_tutors GET      /admin/tutors(.:format)                                            admin/tutors#index
#                                                  POST     /admin/tutors(.:format)                                            admin/tutors#create
#                                  new_admin_tutor GET      /admin/tutors/new(.:format)                                        admin/tutors#new
#                                 edit_admin_tutor GET      /admin/tutors/:id/edit(.:format)                                   admin/tutors#edit
#                                      admin_tutor GET      /admin/tutors/:id(.:format)                                        admin/tutors#show
#                                                  PATCH    /admin/tutors/:id(.:format)                                        admin/tutors#update
#                                                  PUT      /admin/tutors/:id(.:format)                                        admin/tutors#update
#                                                  DELETE   /admin/tutors/:id(.:format)                                        admin/tutors#destroy
#                            search_admin_students GET|POST /admin/students/search(.:format)                                   admin/students#search
#                                   admin_students GET      /admin/students(.:format)                                          admin/students#index
#                                                  POST     /admin/students(.:format)                                          admin/students#create
#                                new_admin_student GET      /admin/students/new(.:format)                                      admin/students#new
#                               edit_admin_student GET      /admin/students/:id/edit(.:format)                                 admin/students#edit
#                                    admin_student GET      /admin/students/:id(.:format)                                      admin/students#show
#                                                  PATCH    /admin/students/:id(.:format)                                      admin/students#update
#                                                  PUT      /admin/students/:id(.:format)                                      admin/students#update
#                                                  DELETE   /admin/students/:id(.:format)                                      admin/students#destroy
#                        search_admin_appointments GET|POST /admin/appointments/search(.:format)                               admin/appointments#search
#                               admin_appointments GET      /admin/appointments(.:format)                                      admin/appointments#index
#                                                  POST     /admin/appointments(.:format)                                      admin/appointments#create
#                            new_admin_appointment GET      /admin/appointments/new(.:format)                                  admin/appointments#new
#                           edit_admin_appointment GET      /admin/appointments/:id/edit(.:format)                             admin/appointments#edit
#                                admin_appointment GET      /admin/appointments/:id(.:format)                                  admin/appointments#show
#                                                  PATCH    /admin/appointments/:id(.:format)                                  admin/appointments#update
#                                                  PUT      /admin/appointments/:id(.:format)                                  admin/appointments#update
#                                                  DELETE   /admin/appointments/:id(.:format)                                  admin/appointments#destroy
#                               search_admin_slots GET|POST /admin/slots/search(.:format)                                      admin/slots#search
#                                      admin_slots GET      /admin/slots(.:format)                                             admin/slots#index
#                                                  POST     /admin/slots(.:format)                                             admin/slots#create
#                                   new_admin_slot GET      /admin/slots/new(.:format)                                         admin/slots#new
#                                  edit_admin_slot GET      /admin/slots/:id/edit(.:format)                                    admin/slots#edit
#                                       admin_slot GET      /admin/slots/:id(.:format)                                         admin/slots#show
#                                                  PATCH    /admin/slots/:id(.:format)                                         admin/slots#update
#                                                  PUT      /admin/slots/:id(.:format)                                         admin/slots#update
#                                                  DELETE   /admin/slots/:id(.:format)                                         admin/slots#destroy
#                             search_admin_schools GET|POST /admin/schools/search(.:format)                                    admin/schools#search
#                                    admin_schools GET      /admin/schools(.:format)                                           admin/schools#index
#                                                  POST     /admin/schools(.:format)                                           admin/schools#create
#                                 new_admin_school GET      /admin/schools/new(.:format)                                       admin/schools#new
#                                edit_admin_school GET      /admin/schools/:id/edit(.:format)                                  admin/schools#edit
#                                     admin_school GET      /admin/schools/:id(.:format)                                       admin/schools#show
#                                                  PATCH    /admin/schools/:id(.:format)                                       admin/schools#update
#                                                  PUT      /admin/schools/:id(.:format)                                       admin/schools#update
#                                                  DELETE   /admin/schools/:id(.:format)                                       admin/schools#destroy
#                                       admin_home GET      /admin/home(.:format)                                              admin/home#index
#                    api_v1_school_subject_courses GET      /api/v1/schools/:school_id/subjects/:subject_id/courses(.:format)  api/v1/courses#index {:format=>:json}
#                           api_v1_school_subjects GET      /api/v1/schools/:school_id/subjects(.:format)                      api/v1/subjects#index {:format=>:json}
#                               api_v1_tutor_slots GET      /api/v1/tutors/:tutor_id/slots(.:format)                           api/v1/slots#index {:format=>:json}
#                                                  POST     /api/v1/tutors/:tutor_id/slots(.:format)                           api/v1/slots#create {:format=>:json}
#                                api_v1_tutor_slot GET      /api/v1/tutors/:tutor_id/slots/:id(.:format)                       api/v1/slots#show {:format=>:json}
#                                                  DELETE   /api/v1/tutors/:tutor_id/slots/:id(.:format)                       api/v1/slots#destroy {:format=>:json}
#                        api_v1_tutor_slots_update POST     /api/v1/tutors/:tutor_id/slots/update(.:format)                    api/v1/slots#update_slots {:format=>:json}
#              reschedule_api_v1_tutor_appointment PUT      /api/v1/tutors/:tutor_id/appointments/:id/reschedule(.:format)     api/v1/tutor_appointments#reschedule {:format=>:json}
#                  cancel_api_v1_tutor_appointment PUT      /api/v1/tutors/:tutor_id/appointments/:id/cancel(.:format)         api/v1/tutor_appointments#cancel {:format=>:json}
#                        api_v1_tutor_appointments GET      /api/v1/tutors/:tutor_id/appointments(.:format)                    api/v1/tutor_appointments#index {:format=>:json}
#                         api_v1_tutor_appointment GET      /api/v1/tutors/:tutor_id/appointments/:id(.:format)                api/v1/tutor_appointments#show {:format=>:json}
#            reschedule_api_v1_student_appointment PUT      /api/v1/students/:student_id/appointments/:id/reschedule(.:format) api/v1/student_appointments#reschedule {:format=>:json}
#                cancel_api_v1_student_appointment PUT      /api/v1/students/:student_id/appointments/:id/cancel(.:format)     api/v1/student_appointments#cancel {:format=>:json}
#                      api_v1_student_appointments GET      /api/v1/students/:student_id/appointments(.:format)                api/v1/student_appointments#index {:format=>:json}
#                       api_v1_student_appointment GET      /api/v1/students/:student_id/appointments/:id(.:format)            api/v1/student_appointments#show {:format=>:json}
#                             api_v1_search_tutors GET      /api/v1/search/tutors(.:format)                                    api/v1/search#tutors {:format=>:json}
#                                      sidekiq_web          /sidekiq                                                           Sidekiq::Web
#

Rails.application.routes.draw do

  root                         'single_views#home'
  get '/search'             => 'single_views#tutor_search'
  get '/restricted-access'  => 'single_views#restricted_access'
  get '/about-us'           => 'single_views#about_us'
  get '/faqs'               => 'single_views#faqs'
  get '/partnerships'       => 'single_views#partnerships'
  get '/become-a-tutor'     => 'single_views#tutor_landing'
  get '/contact'            => 'single_views#contact'

  devise_for :users, controllers: { registrations: "tutor_registration" }
  resources :tutors, :tutor_courses, :slots

  resources :users, only: [:update], path: '' do
    scope module: :dashboard do
      member do
          get  '/dashboard/home'                              => 'home#index'
          get  '/dashboard/schedule'                          => 'schedule#index'
          get  '/dashboard/courses'                           => 'courses#index'
          get  '/dashboard/profile'                           => 'profile#index'
          get  '/dashboard/edit_profile'                      => 'profile#edit'
          get  '/dashboard/settings/account_settings'         => 'settings#account_settings'
          get  '/dashboard/settings/private_information'      => 'settings#private_information'
          get  '/dashboard/settings/profile_settings'         => 'settings#profile_settings'
          get  '/dashboard/settings/appointment_settings'     => 'settings#appointment_settings'
          get  '/dashboard/settings/tutor_payment_settings'   => 'settings#tutor_payment_settings'
          get  '/dashboard/settings/student_payment_settings' => 'settings#student_payment_settings'
          get  '/dashboard/settings/appointment_history'      => 'settings#appointment_history'
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
    resources :tutors       do collection { match 'search' => 'tutors#search', via: [:get, :post], as: :search } end
    resources :students     do collection { match 'search' => 'students#search', via: [:get, :post], as: :search } end
    resources :appointments do collection { match 'search' => 'appointments#search', via: [:get, :post], as: :search } end
    resources :slots        do collection { match 'search' => 'slots#search', via: [:get, :post], as: :search } end
    resources :schools      do collection { match 'search' => 'schools#search', via: [:get, :post], as: :search } end
    get 'home'   => 'home#index'
  end

  # the 'only: []' syntax below after 'resources: collection_name' manually specifies which actions we want for a resource in order to avoid many extra, unused routes
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
        resources :appointments, only: [:index, :show, :create], controller: 'tutor_appointments' do 
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

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
