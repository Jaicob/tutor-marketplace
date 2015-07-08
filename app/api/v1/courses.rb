module V1
  class Courses < Grape::API

    include V1::Defaults

    resource :courses do 
      desc "Returns list of all courses"
      get do
        Course.all.as_json
      end

      desc "Returns a specific course"
      get ":id" do 
        Course.find(params[:id]).as_json
      end

      desc "Updates a specific course's attributes"
      put ":id" do
        @course = Course.find(params[:id])
        if @course.update_attributes(params)
          return @course.as_json
        else
          return "There was an error updating the tutor."
        end
      end
    end
  end
end