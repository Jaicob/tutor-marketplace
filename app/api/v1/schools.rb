module V1
  class Schools < Grape::API

    include V1::Defaults

    resource :schools do 
      desc "Returns list of all schools"
      get do
        School.all
      end

      desc "Returns a specific school"
      get ":id" do 
        School.find(params[:id])
      end

      desc "Returns a specific school and all of its courses"
      get ":id/courses" do 
        School.find(params[:id]).courses
      end

      desc "Returns a specific school and all of its subjects"
      get ":id/subjects" do 
        School.find(params[:id]).subjects
      end

      desc "Returns a specific school and its courses for a specific subject"
      get ":id/subjects/:subject_id/courses" do 
        School.find(params[:id]).courses.find_all do |course| 
          course.subject_id == params[:subject_id].to_i
        end
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