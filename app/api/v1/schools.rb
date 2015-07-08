module V1
  class Schools < Grape::API

    include V1::Defaults

    resource :schools do 
      desc "Returns list of all schools"
      get do
        School.all.as_json
      end

      desc "Returns a specific school"
      get ":id" do 
        School.find(params[:id]).as_json
      end

      desc "Returns a specific school and its subjects"
      get ":id/subjects" do 
        School.find(params[:id]).subjects
      end

      desc "Updates a specific school's attributes"
      put ":id" do
        @school = School.find(params[:id])
        if @school.update_attributes(params)
          return @school.as_json
        else
          return "There was an error updating the tutor."
        end
      end


    end
  end
end