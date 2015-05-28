Rails.application.routes.draw do
  devise_for :users
  mount Upmin::Engine => '/admin'
  root to: "static_pages#home"
end
