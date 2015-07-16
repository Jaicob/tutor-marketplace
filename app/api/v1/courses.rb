module V1
  class Courses < Grape::API

    include V1::Defaults

    params do 
      optional :id, type: Integer 
      optional :school_id, type: Integer
      optional :subject, type: String 
      optional :call_number, type: Integer 
      optional :friendly_name, type: String
    end

    resource :courses do 
      desc "Returns list of all courses"
      get do
        Course.all
      end

      desc "Returns a specific course"
      get ":id" do 
        Course.find(params[:id])
      end

      desc "Updates a specific course's attributes"
      put ":id" do
        @course = Course.find(params[:id])
        if @course.update_attributes(declared_params)
          return @course
        else
          return "There was an error updating the tutor: #{@course.errors.full_messages}"
        end
      end
    end
  end
end