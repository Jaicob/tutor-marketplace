Rails.application.routes.draw do
  resources :tutors
  resources :courses
  resources :subjects
  resources :schools
  resources :tutor_courses
  devise_for :users
  mount Upmin::Engine => '/admin'
  root to: "static_pages#home"
end
