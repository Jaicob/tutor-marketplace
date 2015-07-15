module V1
  class Tutors < Grape::API

    include V1::Defaults

    resource :tutors do 

      helpers do 
        def tutor
          Tutor.find(params[:id])
        end
      end

      desc "Returns list of all tutors"
      get do
        Tutor.all
      end

      desc "Returns a specific tutor"
      get ":id" do 
        tutor
      end

      desc "Updates a specific tutor's attributes"
      put ":id" do
        @tutor = tutor
        if @tutor.update_attributes(params)
          return @tutor.as_json
        else
          return "There was an error updating the tutor."
        end
      end

      
    end
  end
end