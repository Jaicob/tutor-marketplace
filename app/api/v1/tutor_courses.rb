module V1
  class TutorCourses < Grape::API

    include V1::Defaults

    resource :tutor_courses do 
      desc "Returns list of all tutor_courses"
      get do
        TutorCourse.all.as_json
      end

      desc "Returns a specific tutor_course"
      get ":id" do 
        TutorCourse.find(params[:id]).as_json
      end

      desc "Updates a specific tutor_course's attributes"
      put ":id" do
        @tutor_course = TutorCourse.find(params[:id])
        if @tutor_course.update_attributes(params)
          return @tutor_course.as_json
        else
          return "There was an error updating the tutor."
        end
      end
    end
  end
end