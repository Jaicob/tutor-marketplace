module V1
  class Tutors < Grape::API

    include V1::Defaults

    resource :tutors do 
      desc "Returns list of all tutors"
      get do
        Tutor.all.as_json
      end

      desc "Returns a specific tutor"
      get ":id" do 
        Tutor.find(params[:id]).as_json
      end

      desc "Updates a specific tutor's attributes"
      put ":id" do
        @tutor = Tutor.find(params[:id])
        if @tutor.update_attributes(params)
          return @tutor.as_json
        else
          return "There was an error updating the tutor."
        end
      end
    end
  end
end