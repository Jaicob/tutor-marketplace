module V1
  class Users < Grape::API

    include V1::Defaults

    resources :users do 

      desc 'Returns list of all users'
      get do
        User.all
      end

    end
  end
end