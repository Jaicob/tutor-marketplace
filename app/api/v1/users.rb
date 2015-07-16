module V1
  class Users < Grape::API

    include V1::Defaults

      helpers do 
        def user
          User.find(params[:id])
        end
      end

      params do 
        optional  :id,           type:  Integer          
        optional  :email,        type: String           
        optional  :first_name,   type: String
        optional  :last_name,    type: String
        optional  :role,         type: Integer         
        optional  :slug,         type: String
      end

    resources :users do 

      desc 'Returns list of all users'
      get do
        User.all
      end

      desc 'Returns a user'
      get ":id" do
        user 
      end

    end
  end
end