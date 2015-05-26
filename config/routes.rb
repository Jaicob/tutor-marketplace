Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'
  devise_for :users
end
