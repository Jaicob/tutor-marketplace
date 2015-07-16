module V1
  class TutorCourses < Grape::API

    include V1::Defaults


      helpers do 
        def tutor_course
          TutorCourse.find(params[:id])
        end
      end

      params do 
        optional :id, type: Integer 
        optional :tutor_id, type: Integer
        optional :course_id, type: Integer 
        optional :rate, type: String
      end


    #
    # => DO WE NEED TUTOR_COURSES ON THEIR OWN EVER? OR CAN THEY ALWAYS BE IN THE CONTEXT OF TUTORS AS BELOW THS RESOURCE BLOCK
    #

    resource :tutor_courses do 
      desc "Returns list of all tutor_courses"
      get do
        TutorCourse.all
      end

      desc "Returns a specific tutor_course"
      get ":id" do 
        tutor_course
      end

      desc "Updates a specific tutor_course's attributes"
      put ":id" do
        @tutor_course = tutor_course
        if @tutor_course.update_attributes(params)
          return @tutor_course
        else
          return "There was an error updating the tutor."
        end
      end
    end


    resource :tutors do 
      segment "/:tutor_id" do
        resource :tutor_courses do

          helpers do 
            def tutor
              tutor = Tutor.find(params[:tutor_id])
            end
          end

          desc "Returns all tutor_course for a tutor"
          get do 
            tutor.tutor_courses
          end

          desc "Returns one of a tutor's tutor_courses"
          get ":tutor_course_id" do
            TutorCourse.find(params[:tutor_course_id])
          end

        end
      end
    end
  end
end