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