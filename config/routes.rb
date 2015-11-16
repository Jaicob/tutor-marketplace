# == Route Map
#
#                                Prefix Verb     URI Pattern                                                        Controller#Action
#                                  root GET      /                                                                  single_views#home
#                           get_started GET      /get-started(.:format)                                             single_views#student_landing
#                        become_a_tutor GET      /become-a-tutor(.:format)                                          single_views#tutor_landing
#                                search GET      /search(.:format)                                                  single_views#search
#                      search_from_home POST     /search(.:format)                                                  search#search_from_home
#                     restricted_access GET      /restricted-access(.:format)                                       single_views#restricted_access
#                                 about GET      /about(.:format)                                                   single_views#about
#                                  faqs GET      /faqs(.:format)                                                    single_views#faqs
#                              partners GET      /partners(.:format)                                                single_views#partners
#                               contact GET      /contact(.:format)                                                 single_views#contact
#                        privacy_policy GET      /privacy-policy(.:format)                                          single_views#privacy_policy
#                  terms_and_conditions GET      /terms-and-conditions(.:format)                                    single_views#terms_and_conditions
#                            set_school POST     /set-school(.:format)                                              cookies#set_school_id_cookie
#                         change_school POST     /change-school(.:format)                                           cookies#change_school_id_cookie
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
#                                  user PATCH    /users/:id(.:format)                                               users#update
#                                       PUT      /users/:id(.:format)                                               users#update
#                                       DELETE   /users/:id(.:format)                                               users#destroy
#                            home_tutor GET      /tutors/:id/home(.:format)                                         dashboard/tutor/home#index
#                     cancel_appt_tutor PUT      /tutors/:id/cancel_appt/:appt_id(.:format)                         dashboard/tutor/home#cancel_appt
#                        schedule_tutor GET      /tutors/:id/schedule(.:format)                                     dashboard/tutor/schedule#index
#                         profile_tutor GET      /tutors/:id/profile(.:format)                                      dashboard/tutor/profile#index
#                         account_tutor GET      /tutors/:id/settings/account(.:format)                             dashboard/tutor/settings#account
#                    edit_profile_tutor GET      /tutors/:id/settings/edit_profile(.:format)                        dashboard/tutor/settings#edit_profile
#            appointment_settings_tutor GET      /tutors/:id/settings/appointment_settings(.:format)                dashboard/tutor/settings#appointment_settings
#                    payment_info_tutor GET      /tutors/:id/settings/payment_info(.:format)                        dashboard/tutor/settings#payment_info
#                    edit_address_tutor GET      /tutors/:id/settings/edit_address(.:format)                        dashboard/tutor/settings#edit_address
#             appointment_history_tutor GET      /tutors/:id/settings/appointment_history(.:format)                 dashboard/tutor/settings#appointment_history
#         tutor_payment_info_form_tutor GET      /tutors/:id/tutor_payment_info_form(.:format)                      tutors#tutor_payment_info_form
#       update_tutor_payment_info_tutor PATCH    /tutors/:id/update_tutor_payment_info(.:format)                    tutors#update_tutor_payment_info
#          onboarding_application_tutor GET      /tutors/:id/onboarding/application(.:format)                       tutor_onboarding#application
#              onboarding_courses_tutor GET      /tutors/:id/onboarding/courses(.:format)                           tutor_onboarding#courses
#             onboarding_schedule_tutor GET      /tutors/:id/onboarding/schedule(.:format)                          tutor_onboarding#schedule
#      onboarding_payment_details_tutor GET      /tutors/:id/onboarding/payment_details(.:format)                   tutor_onboarding#payment_details
#              submit_application_tutor PUT      /tutors/:id/onboarding/application(.:format)                       tutor_onboarding#submit_application
#                  submit_courses_tutor PUT      /tutors/:id/onboarding/application(.:format)                       tutor_onboarding#submit_courses
#                 submit_schedule_tutor PUT      /tutors/:id/onboarding/application(.:format)                       tutor_onboarding#submit_schedule
#          submit_payment_details_tutor PUT      /tutors/:id/onboarding/application(.:format)                       tutor_onboarding#submit_payment_details
#                         tutor_courses GET      /tutors/:tutor_id/courses(.:format)                                dashboard/tutor/courses#index
#                                       POST     /tutors/:tutor_id/courses(.:format)                                dashboard/tutor/courses#create
#                      new_tutor_course GET      /tutors/:tutor_id/courses/new(.:format)                            dashboard/tutor/courses#new
#                     edit_tutor_course GET      /tutors/:tutor_id/courses/:id/edit(.:format)                       dashboard/tutor/courses#edit
#                          tutor_course GET      /tutors/:tutor_id/courses/:id(.:format)                            dashboard/tutor/courses#show
#                                       PATCH    /tutors/:tutor_id/courses/:id(.:format)                            dashboard/tutor/courses#update
#                                       PUT      /tutors/:tutor_id/courses/:id(.:format)                            dashboard/tutor/courses#update
#                                       DELETE   /tutors/:tutor_id/courses/:id(.:format)                            dashboard/tutor/courses#destroy
#                      tutor_promotions GET      /tutors/:tutor_id/promotions(.:format)                             dashboard/tutor/promotions#index
#                                       POST     /tutors/:tutor_id/promotions(.:format)                             dashboard/tutor/promotions#create
#                   new_tutor_promotion GET      /tutors/:tutor_id/promotions/new(.:format)                         dashboard/tutor/promotions#new
#                  edit_tutor_promotion GET      /tutors/:tutor_id/promotions/:id/edit(.:format)                    dashboard/tutor/promotions#edit
#                       tutor_promotion GET      /tutors/:tutor_id/promotions/:id(.:format)                         dashboard/tutor/promotions#show
#                                       PATCH    /tutors/:tutor_id/promotions/:id(.:format)                         dashboard/tutor/promotions#update
#                                       PUT      /tutors/:tutor_id/promotions/:id(.:format)                         dashboard/tutor/promotions#update
#                                       DELETE   /tutors/:tutor_id/promotions/:id(.:format)                         dashboard/tutor/promotions#destroy
#                                 tutor PATCH    /tutors/:id(.:format)                                              tutors#update
#                                       PUT      /tutors/:id(.:format)                                              tutors#update
#                                       DELETE   /tutors/:id(.:format)                                              tutors#destroy
#                          home_student GET      /students/:id/home(.:format)                                       dashboard/student/home#index
#                   cancel_appt_student PUT      /students/:id/cancel_appt/:appt_id(.:format)                       dashboard/student/home#cancel_appt
#                        search_student GET      /students/:id/search(.:format)                                     single_views#tutor_search
#                       account_student GET      /students/:id/settings/account(.:format)                           dashboard/student/settings#account
#                  payment_info_student GET      /students/:id/settings/payment_info(.:format)                      dashboard/student/settings#payment_info
#                                       POST     /students/:id/settings/payment_info(.:format)                      dashboard/student/settings#save_payment_info
#             edit_payment_info_student GET      /students/:id/settings/edit_payment_info(.:format)                 dashboard/student/settings#edit_payment_info
#                                       POST     /students/:id/settings/edit_payment_info(.:format)                 dashboard/student/settings#save_payment_info
#           appointment_history_student GET      /students/:id/settings/appointment_history(.:format)               dashboard/student/settings#appointment_history
#                               student PATCH    /students/:id(.:format)                                            students#update
#                                       PUT      /students/:id(.:format)                                            students#update
#                                       DELETE   /students/:id(.:format)                                            students#destroy
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
#           campus_manager_admin_school GET      /admin/schools/:id/campus_manager(.:format)                        admin/schools#edit_campus_manager
#                                       POST     /admin/schools/:id/campus_manager(.:format)                        admin/schools#update_campus_manager
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
#                                       PATCH    /api/v1/tutors/:tutor_id/slots/:id(.:format)                       api/v1/slots#update {:format=>:json}
#                                       PUT      /api/v1/tutors/:tutor_id/slots/:id(.:format)                       api/v1/slots#update {:format=>:json}
#                                       DELETE   /api/v1/tutors/:tutor_id/slots/:id(.:format)                       api/v1/slots#destroy {:format=>:json}
#       api_v1_tutor_slots_update_group POST     /api/v1/tutors/:tutor_id/slots/update_group(.:format)              api/v1/slots#update_slot_group {:format=>:json}
#       api_v1_tutor_slots_delete_group POST     /api/v1/tutors/:tutor_id/slots/delete_group(.:format)              api/v1/slots#destroy_slot_group {:format=>:json}
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
#       api_v1_payments_current_student GET      /api/v1/payments/current_student(.:format)                         api/v1/payments#current_student {:format=>:json}
#                           sidekiq_web          /sidekiq                                                           Sidekiq::Web
#


Rails.application.routes.draw do

  # home_page
  root                         'single_views#home'

  # landing pages
  get '/get-started'          => 'single_views#student_landing'
  get '/become-a-tutor'       => 'single_views#tutor_landing'

  # other single_view pages
  get '/search'               => 'single_views#search'
  post '/search'              => 'search#search_from_home', as: 'search_from_home'
  get '/restricted-access'    => 'single_views#restricted_access'
  get '/about'                => 'single_views#about'
  get '/faqs'                 => 'single_views#faqs'
  get '/partners'             => 'single_views#partners'
  get '/contact'              => 'single_views#contact'
  get '/privacy-policy'       => 'single_views#privacy_policy'
  get '/terms-and-conditions' => 'single_views#terms_and_conditions'
  post '/set-school'          => 'cookies#set_school_id_cookie'
  post '/change-school'       => 'cookies#change_school_id_cookie'

  # custom_devise_routes
  devise_for :users, controllers: { registrations: "tutor_registration" }

  # standard resources for slots
  resources :slots

  # user endpoints for update and destroy
  resources :users, only: [:update, :destroy]

  # all dashboard routes for signed-in tutors
  resources :tutors, only: [:show, :update, :destroy] do
    member do
      get  '/home'                    => 'dashboard/tutor/home#index'
      put  '/cancel_appt/:appt_id'    => 'dashboard/tutor/home#cancel_appt', as: 'cancel_appt'
      get  '/schedule'                => 'dashboard/tutor/schedule#index'
      get  '/profile'                 => 'dashboard/tutor/profile#index'
      scope 'settings' do
        get  '/account'                 => 'dashboard/tutor/settings#account'
        get  '/edit_profile'            => 'dashboard/tutor/settings#edit_profile'
        get  '/appointment_settings'    => 'dashboard/tutor/settings#appointment_settings'
        get  '/payment_info'            => 'dashboard/tutor/settings#payment_info'
        get  '/edit_address'            => 'dashboard/tutor/settings#edit_address'
        get  '/appointment_history'     => 'dashboard/tutor/settings#appointment_history'
      end
      # end of standard dashboard routes

      # stripe account setup routes
      get 'tutor_payment_info_form'     => 'tutors#tutor_payment_info_form', as: 'tutor_payment_info_form'
      patch 'update_tutor_payment_info' => 'tutors#update_tutor_payment_info', as: 'update_tutor_payment_info'

      # new tutor onboarding routes (for loading step-by-step instruction wizard)
      get '/onboarding/application'     => 'tutor_onboarding#application'
      get '/onboarding/courses'         => 'tutor_onboarding#courses'
      get '/onboarding/schedule'        => 'tutor_onboarding#schedule'
      get '/onboarding/payment_details' => 'tutor_onboarding#payment_details'
      put '/onboarding/application'     => 'tutor_onboarding#submit_application', as: 'submit_application'
      put '/onboarding/application'     => 'tutor_onboarding#submit_courses', as: 'submit_courses'
      put '/onboarding/application'     => 'tutor_onboarding#submit_schedule', as: 'submit_schedule'
      put '/onboarding/application'     => 'tutor_onboarding#submit_payment_details', as: 'submit_payment_details'
    end
    resources :courses, controller: 'dashboard/tutor/courses'
    resources :promotions, controller: 'dashboard/tutor/promotions'
  end


  # all dashboard routes for signed-in students
  resources :students, only: [:update, :destroy] do
    member do
      get  '/home'                 => 'dashboard/student/home#index'
      put  '/cancel_appt/:appt_id' => 'dashboard/student/home#cancel_appt', as: 'cancel_appt'
      get  '/search'               => 'single_views#tutor_search'
      scope 'settings' do
        get  '/account'               => 'dashboard/student/settings#account'
        get  '/payment_info'          => 'dashboard/student/settings#payment_info'
        post '/payment_info'          => 'dashboard/student/settings#save_payment_info'
        get  '/edit_payment_info'     => 'dashboard/student/settings#edit_payment_info'
        post '/edit_payment_info'      => 'dashboard/student/settings#save_payment_info'
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
    resources :schools do
      collection { match 'search' => 'schools#search', via: [:get, :post], as: :search }
      member do
        get   'campus_manager' => 'schools#edit_campus_manager'
        post  'campus_manager' => 'schools#update_campus_manager'
      end
    end
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
        resources :slots, only: [:index, :show, :create, :update, :destroy]
        post '/slots/update_group' => 'slots#update_slot_group' # POST bc carrying data for multiple slots
        post '/slots/delete_group' => 'slots#destroy_slot_group' # POST bc carrying data for multiple slots
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
      get '/payments/current_student' => 'payments#current_student'
      ## special routes for checkout
      # retrieves promo code info for checkout preview
      get '/check_promo_code/:tutor_id/:promo_code' => 'promotions#check_promo_code'
      # creates an appointment without a student_id for a visitor (before student_id is created and attached to appt in the next step of checkout)
      post  '/visitor/create_appointment' => '/api/v1/student_appointments#visitor_create'
    end
  end

  # routes for Sidekiq background processes
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
