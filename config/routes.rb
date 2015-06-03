Rails.application.routes.draw do
  resources :tutors
  resources :courses
  resources :subjects
  resources :schools
  resources :dashboard
  devise_for :users
  mount Upmin::Engine => '/admin'
  root to: "static_pages#home"
end
