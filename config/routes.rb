# == Route Map
#
#                                Prefix Verb     URI Pattern                                                                   Controller#Action
#                                  root GET      /                                                                             single_views#home
#                           get_started GET      /get-started(.:format)                                                        single_views#student_landing
#                        become_a_tutor GET      /become-a-tutor(.:format)                                                     single_views#tutor_landing
#                          welcome_back GET      /welcome-back(.:format)                                                       single_views#existing_tutor_landing
#                 create_existing_tutor POST     /create-existing-tutor(.:format)                                              tutor_onboarding#create_existing_tutor_account
#                                search GET      /search(.:format)                                                             single_views#search
#                      search_from_home POST     /search(.:format)                                                             search#search_from_home
#                     restricted_access GET      /restricted-access(.:format)                                                  single_views#restricted_access
#                                 about GET      /about(.:format)                                                              single_views#about
#                                  faqs GET      /faqs(.:format)                                                               single_views#faqs
#                              partners GET      /partners(.:format)                                                           single_views#partners
#                               contact GET      /contact(.:format)                                                            single_views#contact
#                     privacy_and_terms GET      /privacy-and-terms(.:format)                                                  single_views#privacy_and_terms
#                            set_school POST     /set-school(.:format)                                                         cookies#set_school_id_cookie
#                         change_school POST     /change-school(.:format)                                                      cookies#change_school_id_cookie
#                checkout_select_course GET      /tutors/:id/select_course(.:format)                                           checkout#select_course
#                checkout_set_course_id POST     /tutors/:id/set_course_id(.:format)                                           checkout#set_course_id
#                 checkout_select_times GET      /tutors/:id/select_times(.:format)                                            checkout#select_times
#                    checkout_set_times POST     /tutors/:id/set_appt_times(.:format)                                          checkout#set_times
#              checkout_select_location GET      /tutors/:id/select_location(.:format)                                         checkout#select_location
#                 checkout_set_location POST     /tutors/:id/set_location(.:format)                                            checkout#set_location
#               checkout_review_booking GET      /tutors/:id/review_booking(.:format)                                          checkout#review_booking
#             checkout_apply_promo_code POST     /tutors/:id/apply_promo_code(.:format)                                        checkout#apply_promo_code
#              checkout_process_booking POST     /tutors/:id/process_booking(.:format)                                         checkout#process_booking
#                 checkout_confirmation GET      /tutors/:id/confirmation(.:format)                                            checkout#confirmation
#                      new_user_session GET      /users/sign_in(.:format)                                                      sessions#new
#                          user_session POST     /users/sign_in(.:format)                                                      sessions#create
#                  destroy_user_session DELETE   /users/sign_out(.:format)                                                     sessions#destroy
#                         user_password POST     /users/password(.:format)                                                     devise/passwords#create
#                     new_user_password GET      /users/password/new(.:format)                                                 devise/passwords#new
#                    edit_user_password GET      /users/password/edit(.:format)                                                devise/passwords#edit
#                                       PATCH    /users/password(.:format)                                                     devise/passwords#update
#                                       PUT      /users/password(.:format)                                                     devise/passwords#update
#              cancel_user_registration GET      /users/cancel(.:format)                                                       registrations#cancel
#                     user_registration POST     /users(.:format)                                                              registrations#create
#                 new_user_registration GET      /users/sign_up(.:format)                                                      registrations#new
#                edit_user_registration GET      /users/edit(.:format)                                                         registrations#edit
#                                       PATCH    /users(.:format)                                                              registrations#update
#                                       PUT      /users(.:format)                                                              registrations#update
#                                       DELETE   /users(.:format)                                                              registrations#destroy
#                     user_confirmation POST     /users/confirmation(.:format)                                                 devise/confirmations#create
#                 new_user_confirmation GET      /users/confirmation/new(.:format)                                             devise/confirmations#new
#                                       GET      /users/confirmation(.:format)                                                 devise/confirmations#show
#                accept_user_invitation GET      /users/invitation/accept(.:format)                                            devise/invitations#edit
#                remove_user_invitation GET      /users/invitation/remove(.:format)                                            devise/invitations#destroy
#                       user_invitation POST     /users/invitation(.:format)                                                   devise/invitations#create
#                   new_user_invitation GET      /users/invitation/new(.:format)                                               devise/invitations#new
#                                       PATCH    /users/invitation(.:format)                                                   devise/invitations#update
#                                       PUT      /users/invitation(.:format)                                                   devise/invitations#update
#                                 slots GET      /slots(.:format)                                                              slots#index
#                                       POST     /slots(.:format)                                                              slots#create
#                              new_slot GET      /slots/new(.:format)                                                          slots#new
#                             edit_slot GET      /slots/:id/edit(.:format)                                                     slots#edit
#                                  slot GET      /slots/:id(.:format)                                                          slots#show
#                                       PATCH    /slots/:id(.:format)                                                          slots#update
#                                       PUT      /slots/:id(.:format)                                                          slots#update
#                                       DELETE   /slots/:id(.:format)                                                          slots#destroy
#                                  user PATCH    /users/:id(.:format)                                                          users#update
#                                       PUT      /users/:id(.:format)                                                          users#update
#                                       DELETE   /users/:id(.:format)                                                          users#destroy
#                  public_profile_tutor GET      /tutors/:id(.:format)                                                         tutors#show
#                            home_tutor GET      /tutors/:id/home(.:format)                                                    dashboard/tutor/home#index
#                     cancel_appt_tutor PUT      /tutors/:id/cancel_appt/:appt_id(.:format)                                    dashboard/tutor/home#cancel_appt
#                        schedule_tutor GET      /tutors/:id/schedule(.:format)                                                dashboard/tutor/schedule#index
#                         profile_tutor GET      /tutors/:id/profile(.:format)                                                 dashboard/tutor/profile#index
#                         account_tutor GET      /tutors/:id/settings/account(.:format)                                        dashboard/tutor/settings#account
#                    edit_profile_tutor GET      /tutors/:id/settings/edit_profile(.:format)                                   dashboard/tutor/settings#edit_profile
#            appointment_settings_tutor GET      /tutors/:id/settings/appointment_settings(.:format)                           dashboard/tutor/settings#appointment_settings
#                    payment_info_tutor GET      /tutors/:id/settings/payment_info(.:format)                                   dashboard/tutor/settings#payment_info
#                    edit_address_tutor GET      /tutors/:id/settings/edit_address(.:format)                                   dashboard/tutor/settings#edit_address
#             appointment_history_tutor GET      /tutors/:id/settings/appointment_history(.:format)                            dashboard/tutor/settings#appointment_history
#         tutor_payment_info_form_tutor GET      /tutors/:id/tutor_payment_info_form(.:format)                                 tutors#tutor_payment_info_form
#       update_tutor_payment_info_tutor PATCH    /tutors/:id/update_tutor_payment_info(.:format)                               tutors#update_tutor_payment_info
#        application_for_existing_tutor GET      /tutors/:id/onboarding/existing_tutor(.:format)                               tutor_onboarding#application_for_existing_tutor
#          onboarding_application_tutor GET      /tutors/:id/onboarding/application(.:format)                                  tutor_onboarding#application
#              onboarding_courses_tutor GET      /tutors/:id/onboarding/courses(.:format)                                      tutor_onboarding#courses
#             onboarding_schedule_tutor GET      /tutors/:id/onboarding/schedule(.:format)                                     tutor_onboarding#schedule
#      onboarding_payment_details_tutor GET      /tutors/:id/onboarding/payment_details(.:format)                              tutor_onboarding#payment_details
#              submit_application_tutor PATCH    /tutors/:id/onboarding/application(.:format)                                  tutor_onboarding#submit_application
#                  submit_courses_tutor PATCH    /tutors/:id/onboarding/courses(.:format)                                      tutor_onboarding#submit_courses
#                 submit_schedule_tutor PATCH    /tutors/:id/onboarding/schedule(.:format)                                     tutor_onboarding#submit_schedule
#          submit_payment_details_tutor PATCH    /tutors/:id/onboarding/payment_details(.:format)                              tutor_onboarding#submit_payment_details
# create_course_during_onboarding_tutor POST     /tutors/:id/onboarding/courses(.:format)                                      tutor_onboarding#create_course
# update_course_during_onboarding_tutor PUT      /tutors/:id/onboarding/courses/:tutor_course_id/update(.:format)              tutor_onboarding#update_course
# delete_course_during_onboarding_tutor DELETE   /tutors/:id/onboarding/courses/:tutor_course_id/destroy(.:format)             tutor_onboarding#delete_course
#                         tutor_courses GET      /tutors/:tutor_id/courses(.:format)                                           dashboard/tutor/courses#index
#                                       POST     /tutors/:tutor_id/courses(.:format)                                           dashboard/tutor/courses#create
#                      new_tutor_course GET      /tutors/:tutor_id/courses/new(.:format)                                       dashboard/tutor/courses#new
#                     edit_tutor_course GET      /tutors/:tutor_id/courses/:id/edit(.:format)                                  dashboard/tutor/courses#edit
#                          tutor_course GET      /tutors/:tutor_id/courses/:id(.:format)                                       dashboard/tutor/courses#show
#                                       PATCH    /tutors/:tutor_id/courses/:id(.:format)                                       dashboard/tutor/courses#update
#                                       PUT      /tutors/:tutor_id/courses/:id(.:format)                                       dashboard/tutor/courses#update
#                                       DELETE   /tutors/:tutor_id/courses/:id(.:format)                                       dashboard/tutor/courses#destroy
#                      tutor_promotions GET      /tutors/:tutor_id/promotions(.:format)                                        dashboard/tutor/promotions#index
#                                       POST     /tutors/:tutor_id/promotions(.:format)                                        dashboard/tutor/promotions#create
#                   new_tutor_promotion GET      /tutors/:tutor_id/promotions/new(.:format)                                    dashboard/tutor/promotions#new
#                  edit_tutor_promotion GET      /tutors/:tutor_id/promotions/:id/edit(.:format)                               dashboard/tutor/promotions#edit
#                       tutor_promotion GET      /tutors/:tutor_id/promotions/:id(.:format)                                    dashboard/tutor/promotions#show
#                                       PATCH    /tutors/:tutor_id/promotions/:id(.:format)                                    dashboard/tutor/promotions#update
#                                       PUT      /tutors/:tutor_id/promotions/:id(.:format)                                    dashboard/tutor/promotions#update
#                                       DELETE   /tutors/:tutor_id/promotions/:id(.:format)                                    dashboard/tutor/promotions#destroy
#                                 tutor PATCH    /tutors/:id(.:format)                                                         tutors#update
#                                       PUT      /tutors/:id(.:format)                                                         tutors#update
#                                       DELETE   /tutors/:id(.:format)                                                         tutors#destroy
#                          home_student GET      /students/:id/home(.:format)                                                  dashboard/student/home#index
#       view_reschedule_options_student GET      /students/:id/reschedule/:appt_id(.:format)                                   dashboard/student/home#view_reschedule_options
#               reschedule_appt_student PUT      /students/:id/reschedule/:appt_id(.:format)                                   dashboard/student/home#reschedule_appt
#                   cancel_appt_student PUT      /students/:id/cancel_appt/:appt_id(.:format)                                  dashboard/student/home#cancel_appt
#                        search_student GET      /students/:id/search(.:format)                                                single_views#tutor_search
#                       account_student GET      /students/:id/settings/account(.:format)                                      dashboard/student/settings#account
#                  payment_info_student GET      /students/:id/settings/payment_info(.:format)                                 dashboard/student/settings#payment_info
#                                       POST     /students/:id/settings/payment_info(.:format)                                 dashboard/student/settings#save_payment_info
#             edit_payment_info_student GET      /students/:id/settings/edit_payment_info(.:format)                            dashboard/student/settings#edit_payment_info
#                                       POST     /students/:id/settings/edit_payment_info(.:format)                            dashboard/student/settings#save_payment_info
#           appointment_history_student GET      /students/:id/settings/appointment_history(.:format)                          dashboard/student/settings#appointment_history
#                               student PATCH    /students/:id(.:format)                                                       students#update
#                                       PUT      /students/:id(.:format)                                                       students#update
#                                       DELETE   /students/:id(.:format)                                                       students#destroy
#                  search_admin_courses GET|POST /admin/courses/search(.:format)                                               dashboard/admin/courses#search
#         new_course_list_admin_courses POST     /admin/courses/new_course_list(.:format)                                      dashboard/admin/courses#new_course_list
#  review_new_course_list_admin_courses POST     /admin/courses/review_new_course_list(.:format)                               dashboard/admin/courses#review_new_course_list
#  create_new_course_list_admin_courses POST     /admin/courses/create_new_course_list(.:format)                               dashboard/admin/courses#create_new_course_list
#  review_csv_course_list_admin_courses POST     /admin/courses/review_csv_course_list(.:format)                               dashboard/admin/courses#review_csv_course_list
#  create_csv_course_list_admin_courses POST     /admin/courses/create_csv_course_list(.:format)                               dashboard/admin/courses#create_csv_course_list
#                         admin_courses GET      /admin/courses(.:format)                                                      dashboard/admin/courses#index
#                                       POST     /admin/courses(.:format)                                                      dashboard/admin/courses#create
#                      new_admin_course GET      /admin/courses/new(.:format)                                                  dashboard/admin/courses#new
#                     edit_admin_course GET      /admin/courses/:id/edit(.:format)                                             dashboard/admin/courses#edit
#                          admin_course GET      /admin/courses/:id(.:format)                                                  dashboard/admin/courses#show
#                                       PATCH    /admin/courses/:id(.:format)                                                  dashboard/admin/courses#update
#                                       PUT      /admin/courses/:id(.:format)                                                  dashboard/admin/courses#update
#                                       DELETE   /admin/courses/:id(.:format)                                                  dashboard/admin/courses#destroy
#                   search_admin_tutors GET|POST /admin/tutors/search(.:format)                                                dashboard/admin/tutors#search
#                          admin_tutors GET      /admin/tutors(.:format)                                                       dashboard/admin/tutors#index
#                                       POST     /admin/tutors(.:format)                                                       dashboard/admin/tutors#create
#                       new_admin_tutor GET      /admin/tutors/new(.:format)                                                   dashboard/admin/tutors#new
#                      edit_admin_tutor GET      /admin/tutors/:id/edit(.:format)                                              dashboard/admin/tutors#edit
#                           admin_tutor GET      /admin/tutors/:id(.:format)                                                   dashboard/admin/tutors#show
#                                       PATCH    /admin/tutors/:id(.:format)                                                   dashboard/admin/tutors#update
#                                       PUT      /admin/tutors/:id(.:format)                                                   dashboard/admin/tutors#update
#                                       DELETE   /admin/tutors/:id(.:format)                                                   dashboard/admin/tutors#destroy
#                 search_admin_students GET|POST /admin/students/search(.:format)                                              dashboard/admin/students#search
#                        admin_students GET      /admin/students(.:format)                                                     dashboard/admin/students#index
#                                       POST     /admin/students(.:format)                                                     dashboard/admin/students#create
#                     new_admin_student GET      /admin/students/new(.:format)                                                 dashboard/admin/students#new
#                    edit_admin_student GET      /admin/students/:id/edit(.:format)                                            dashboard/admin/students#edit
#                         admin_student GET      /admin/students/:id(.:format)                                                 dashboard/admin/students#show
#                                       PATCH    /admin/students/:id(.:format)                                                 dashboard/admin/students#update
#                                       PUT      /admin/students/:id(.:format)                                                 dashboard/admin/students#update
#                                       DELETE   /admin/students/:id(.:format)                                                 dashboard/admin/students#destroy
#             search_admin_appointments GET|POST /admin/appointments/search(.:format)                                          dashboard/admin/appointments#search
#                    admin_appointments GET      /admin/appointments(.:format)                                                 dashboard/admin/appointments#index
#                                       POST     /admin/appointments(.:format)                                                 dashboard/admin/appointments#create
#                 new_admin_appointment GET      /admin/appointments/new(.:format)                                             dashboard/admin/appointments#new
#                edit_admin_appointment GET      /admin/appointments/:id/edit(.:format)                                        dashboard/admin/appointments#edit
#                     admin_appointment GET      /admin/appointments/:id(.:format)                                             dashboard/admin/appointments#show
#                                       PATCH    /admin/appointments/:id(.:format)                                             dashboard/admin/appointments#update
#                                       PUT      /admin/appointments/:id(.:format)                                             dashboard/admin/appointments#update
#                                       DELETE   /admin/appointments/:id(.:format)                                             dashboard/admin/appointments#destroy
#                    search_admin_slots GET|POST /admin/slots/search(.:format)                                                 dashboard/admin/slots#search
#                           admin_slots GET      /admin/slots(.:format)                                                        dashboard/admin/slots#index
#                                       POST     /admin/slots(.:format)                                                        dashboard/admin/slots#create
#                        new_admin_slot GET      /admin/slots/new(.:format)                                                    dashboard/admin/slots#new
#                       edit_admin_slot GET      /admin/slots/:id/edit(.:format)                                               dashboard/admin/slots#edit
#                            admin_slot GET      /admin/slots/:id(.:format)                                                    dashboard/admin/slots#show
#                                       PATCH    /admin/slots/:id(.:format)                                                    dashboard/admin/slots#update
#                                       PUT      /admin/slots/:id(.:format)                                                    dashboard/admin/slots#update
#                                       DELETE   /admin/slots/:id(.:format)                                                    dashboard/admin/slots#destroy
#                  search_admin_schools GET|POST /admin/schools/search(.:format)                                               dashboard/admin/schools#search
#                         admin_schools GET      /admin/schools(.:format)                                                      dashboard/admin/schools#index
#                                       POST     /admin/schools(.:format)                                                      dashboard/admin/schools#create
#                      new_admin_school GET      /admin/schools/new(.:format)                                                  dashboard/admin/schools#new
#                     edit_admin_school GET      /admin/schools/:id/edit(.:format)                                             dashboard/admin/schools#edit
#                          admin_school GET      /admin/schools/:id(.:format)                                                  dashboard/admin/schools#show
#                                       PATCH    /admin/schools/:id(.:format)                                                  dashboard/admin/schools#update
#                                       PUT      /admin/schools/:id(.:format)                                                  dashboard/admin/schools#update
#                                       DELETE   /admin/schools/:id(.:format)                                                  dashboard/admin/schools#destroy
#               search_admin_promotions GET|POST /admin/promotions/search(.:format)                                            dashboard/admin/promotions#search
#                      admin_promotions GET      /admin/promotions(.:format)                                                   dashboard/admin/promotions#index
#                                       POST     /admin/promotions(.:format)                                                   dashboard/admin/promotions#create
#                   new_admin_promotion GET      /admin/promotions/new(.:format)                                               dashboard/admin/promotions#new
#                  edit_admin_promotion GET      /admin/promotions/:id/edit(.:format)                                          dashboard/admin/promotions#edit
#                       admin_promotion GET      /admin/promotions/:id(.:format)                                               dashboard/admin/promotions#show
#                                       PATCH    /admin/promotions/:id(.:format)                                               dashboard/admin/promotions#update
#                                       PUT      /admin/promotions/:id(.:format)                                               dashboard/admin/promotions#update
#                                       DELETE   /admin/promotions/:id(.:format)                                               dashboard/admin/promotions#destroy
#                api_v1_school_subjects GET      /api/v1/schools/:school_id/subjects(.:format)                                 api/v1/subjects#index {:format=>:json}
#    api_v1_school_subjects_all_options GET      /api/v1/schools/:school_id/subjects-all-options(.:format)                     api/v1/subjects#all_options {:format=>:json}
#                                       GET      /api/v1/schools/:school_id/subjects/:subject_id/courses(.:format)             api/v1/courses#index {:format=>:json}
#                                       GET      /api/v1/schools/:school_id/subjects/:subject_id/courses-all-options(.:format) api/v1/courses#all_options {:format=>:json}
#                  courses_api_v1_tutor GET      /api/v1/tutors/:id/courses(.:format)                                          api/v1/tutor_courses#index {:format=>:json}
#       update_group_api_v1_tutor_slots POST     /api/v1/tutors/:tutor_id/slots/update_group(.:format)                         api/v1/slots#update_slot_group {:format=>:json}
#       delete_group_api_v1_tutor_slots POST     /api/v1/tutors/:tutor_id/slots/delete_group(.:format)                         api/v1/slots#destroy_slot_group {:format=>:json}
#                    api_v1_tutor_slots GET      /api/v1/tutors/:tutor_id/slots(.:format)                                      api/v1/slots#index {:format=>:json}
#                                       POST     /api/v1/tutors/:tutor_id/slots(.:format)                                      api/v1/slots#create {:format=>:json}
#                     api_v1_tutor_slot GET      /api/v1/tutors/:tutor_id/slots/:id(.:format)                                  api/v1/slots#show {:format=>:json}
#                                       PATCH    /api/v1/tutors/:tutor_id/slots/:id(.:format)                                  api/v1/slots#update {:format=>:json}
#                                       PUT      /api/v1/tutors/:tutor_id/slots/:id(.:format)                                  api/v1/slots#update {:format=>:json}
#                                       DELETE   /api/v1/tutors/:tutor_id/slots/:id(.:format)                                  api/v1/slots#destroy {:format=>:json}
#       cancel_api_v1_tutor_appointment PUT      /api/v1/tutors/:tutor_id/appointments/:id/cancel(.:format)                    api/v1/tutor_appointments#cancel {:format=>:json}
#             api_v1_tutor_appointments GET      /api/v1/tutors/:tutor_id/appointments(.:format)                               api/v1/tutor_appointments#index {:format=>:json}
#              api_v1_tutor_appointment GET      /api/v1/tutors/:tutor_id/appointments/:id(.:format)                           api/v1/tutor_appointments#show {:format=>:json}
#    delete_api_v1_student_appointments DELETE   /api/v1/students/:student_id/appointments/delete(.:format)                    api/v1/student_appointments#delete {:format=>:json}
# reschedule_api_v1_student_appointment PUT      /api/v1/students/:student_id/appointments/:id/reschedule(.:format)            api/v1/student_appointments#reschedule {:format=>:json}
#     cancel_api_v1_student_appointment PUT      /api/v1/students/:student_id/appointments/:id/cancel(.:format)                api/v1/student_appointments#cancel {:format=>:json}
#           api_v1_student_appointments GET      /api/v1/students/:student_id/appointments(.:format)                           api/v1/student_appointments#index {:format=>:json}
#                                       POST     /api/v1/students/:student_id/appointments(.:format)                           api/v1/student_appointments#create {:format=>:json}
#            api_v1_student_appointment GET      /api/v1/students/:student_id/appointments/:id(.:format)                       api/v1/student_appointments#show {:format=>:json}
#                  api_v1_search_tutors GET      /api/v1/search/tutors(.:format)                                               api/v1/search#tutors {:format=>:json}
#               api_v1_check_promo_code GET      /api/v1/check_promo_code/:tutor_id/:promo_code(.:format)                      api/v1/promotions#check_promo_code {:format=>:json}
#     api_v1_visitor_create_appointment POST     /api/v1/visitor/create_appointment(.:format)                                  api/v1/student_appointments#visitor_create {:format=>:json}
#                api_v1_process_payment POST     /api/v1/payments/process_payment(.:format)                                    api/v1/payments#process_payment {:format=>:json}
#                   api_v1_get_customer GET      /api/v1/payments/student/:student_id/customer(.:format)                       api/v1/payments#get_customer {:format=>:json}
#                api_v1_create_customer POST     /api/v1/payments/student/:student_id/customer(.:format)                       api/v1/payments#create_customer {:format=>:json}
#            api_v1_update_default_card POST     /api/v1/payments/student/:student_id/default-card(.:format)                   api/v1/payments#update_default_card {:format=>:json}
#                           sidekiq_web          /sidekiq                                                                      Sidekiq::Web
#


Rails.application.routes.draw do

  # home_page
  root                         'single_views#landing_home'

  # landing pages
  get '/get-started'          => 'single_views#landing_new_student'
  get '/become-a-tutor'       => 'single_views#landing_new_tutor'
  
  # landing page and post url for registering existing tutors
  get '/welcome-back'         => 'single_views#existing_tutor_landing'
  post '/create-existing-tutor'  => 'tutor_onboarding#create_existing_tutor_account'

  # other single_view pages
  get '/search'               => 'single_views#search'
  post '/search'              => 'search#search_from_home', as: 'search_from_home'
  get '/restricted-access'    => 'single_views#restricted_access'
  get '/about'                => 'single_views#about'
  get '/faqs'                 => 'single_views#faqs'
  get '/partners'             => 'single_views#partners'
  get '/contact'              => 'single_views#contact'
  get '/privacy-and-terms'    => 'single_views#privacy_and_terms'
  post '/set-school'          => 'cookies#set_school_id_cookie'
  post '/change-school'       => 'cookies#change_school_id_cookie'

  # checkout pages
  scope '/tutors/:id' do 
    get   '/select_course'    => 'checkout#select_course', as: 'checkout_select_course'
    post  '/set_course_id'    => 'checkout#set_course_id', as: 'checkout_set_course_id'
    get   '/select_times'     => 'checkout#select_times', as: 'checkout_select_times'
    post  '/set_appt_times'   => 'checkout#set_times', as: 'checkout_set_times'
    get   '/select_location'  => 'checkout#select_location', as: 'checkout_select_location'
    post  '/set_location'     => 'checkout#set_location', as: 'checkout_set_location'
    get   '/review_booking'   => 'checkout#review_booking', as: 'checkout_review_booking'
    post  '/apply_promo_code' => 'checkout#apply_promo_code', as: 'checkout_apply_promo_code'
    post  '/process_booking'  => 'checkout#process_booking', as: 'checkout_process_booking'
    get   '/confirmation'     => 'checkout#confirmation', as: 'checkout_confirmation'
  end

  # custom_devise_routes
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}

  # standard resources for slots
  resources :slots

  # user endpoints for update and destroy
  resources :users, only: [:update, :destroy]

  # tutor show route for public_profile
  get '/tutors/:id' => 'tutors#show', as: 'public_profile_tutor'

  # all dashboard routes for signed-in tutors
  resources :tutors, only: [:update, :destroy] do
    member do
      # dashboard routes below
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
      get '/onboarding/existing_tutor'  => 'tutor_onboarding#application_for_existing_tutor', as: 'application_for_existing'
      get '/onboarding/application'     => 'tutor_onboarding#application'
      get '/onboarding/courses'         => 'tutor_onboarding#courses'
      get '/onboarding/schedule'        => 'tutor_onboarding#schedule'
      get '/onboarding/payment_details' => 'tutor_onboarding#payment_details'
      patch '/onboarding/application'      => 'tutor_onboarding#submit_application', as: 'submit_application'
      patch '/onboarding/courses'          => 'tutor_onboarding#submit_courses', as: 'submit_courses'
      patch '/onboarding/schedule'         => 'tutor_onboarding#submit_schedule', as: 'submit_schedule'
      patch '/onboarding/payment_details'  => 'tutor_onboarding#submit_payment_details', as: 'submit_payment_details'
      post  '/onboarding/courses'          => 'tutor_onboarding#create_course', as: 'create_course_during_onboarding'
      put '/onboarding/courses/:tutor_course_id/update' => 'tutor_onboarding#update_course', as: 'update_course_during_onboarding'
      delete '/onboarding/courses/:tutor_course_id/destroy' => 'tutor_onboarding#delete_course', as: 'delete_course_during_onboarding'
    end
    resources :courses, controller: 'dashboard/tutor/courses'
    resources :promotions, controller: 'dashboard/tutor/promotions'
  end


  # all dashboard routes for signed-in students
  resources :students, only: [:update, :destroy] do
    member do
      get  '/home'                 => 'dashboard/student/home#index'
      get  '/reschedule/:appt_id'  => 'dashboard/student/home#view_reschedule_options', as: 'view_reschedule_options'
      put  '/reschedule/:appt_id'  => 'dashboard/student/home#reschedule_appt', as: 'reschedule_appt'
      put  '/cancel_appt/:appt_id' => 'dashboard/student/home#cancel_appt', as: 'cancel_appt'
      get  '/search'               => 'single_views#tutor_search'
      scope 'settings' do
        get  '/account'               => 'dashboard/student/settings#account'
        get  '/payment_info'          => 'dashboard/student/settings#payment_info'
        post '/payment_info'          => 'dashboard/student/settings#save_payment_info'
        get  '/edit_payment_info'     => 'dashboard/student/settings#edit_payment_info'
        post '/edit_payment_info'     => 'dashboard/student/settings#save_payment_info'
        get  '/appointment_history'   => 'dashboard/student/settings#appointment_history'
      end
    end
  end

  # restricted admin-only area routes (the collections after the resources are for ransack search)
  scope module: 'dashboard' do
    namespace :admin do
      resources :courses do
        collection do
          match 'search' => 'courses#search', via: [:get, :post], as: :search
          post 'new_course_list' => 'courses#new_course_list'
          post 'review_new_course_list' => 'courses#review_new_course_list'
          post 'create_new_course_list' => 'courses#create_new_course_list'
          post 'review_csv_course_list' => 'courses#review_csv_course_list'
          post 'create_csv_course_list' => 'courses#create_csv_course_list'
        end
      end
      resources :tutors do collection { match 'search' => 'tutors#search', via: [:get, :post], as: :search } end
      resources :students do collection { match 'search' => 'students#search', via: [:get, :post], as: :search } end
      resources :appointments do collection { match 'search' => 'appointments#search', via: [:get, :post], as: :search } end
      resources :slots do collection { match 'search' => 'slots#search', via: [:get, :post], as: :search } end
      resources :schools do
        collection { match 'search' => 'schools#search', via: [:get, :post], as: :search }
      end
      resources :promotions do collection { match 'search' => 'promotions#search', via: [:get, :post], as: :search } end
    end
  end

  # API routes
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :schools, only: [] do
        get '/subjects/'                                    => 'subjects#index'
        get '/subjects-all-options/'                        => 'subjects#all_options'
        get '/subjects/:subject_id/courses'                 => 'courses#index'
        get '/subjects/:subject_id/courses-all-options'     => 'courses#all_options'
      end

      resources :tutors, only: [] do
        member do
          get '/courses' => 'tutor_courses#index'
        end
        resources :slots, only: [:index, :show, :create, :update, :destroy] do
          collection do
            post '/update_group' => 'slots#update_slot_group' # POST bc carrying data for multiple slots
            post '/delete_group' => 'slots#destroy_slot_group' # POST bc carrying data for multiple slots
          end
        end
        resources :appointments, only: [:index, :show], controller: 'tutor_appointments' do
          member do
            put 'cancel'
          end
        end
      end

      resources :students, only: [] do
        resources :appointments, only: [:index, :show, :create], controller: 'student_appointments' do
          collection do
          	delete 'delete'
          end
          member do
            put 'reschedule'
            put 'cancel'
          end
        end
      end

      get  '/search/tutors'  => 'search#tutors'
      get  '/check_promo_code/:tutor_id/:promo_code' => 'promotions#check_promo_code',      as: 'check_promo_code'
      post '/visitor/create_appointment'             => 'student_appointments#visitor_create'
      post '/payments/process_payment'               => 'payments#process_payment',         as: 'process_payment'
      get  '/payments/student/:student_id/customer'      => 'payments#get_customer',        as: 'get_customer'
      post '/payments/student/:student_id/customer'      => 'payments#create_customer',     as: 'create_customer'
      post '/payments/student/:student_id/default-card'  => 'payments#update_default_card', as: 'update_default_card'
    end
  end

  # routes for Sidekiq background processes
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end