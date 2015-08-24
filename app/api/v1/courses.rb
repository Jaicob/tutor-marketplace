module V1
  class Courses < Grape::API

    include V1::Defaults

     helpers do 

        def course
          Course.find(params[:id])
        end

        def school 
          School.find(params[:school_id])
        end
      end

      params do 
        optional :id, type: Integer 
        optional :school_id, type: Integer
        optional :subject, type: Hash 
        optional :call_number, type: Integer 
        optional :friendly_name, type: String
      end

    resource :schools do 

      desc "Returns courses for a school"
      get ":id/courses" do 
        school.courses
      end

      desc "Returns courses for a school and subject"
      get ":id/subjects/:subject_id/courses" do 
        school = School.find(params[:id])
        school.courses.find_all do |course| 
          course.subject_id == params[:subject_id].to_i
        end
      end

      segment "/:school_id" do
        resource :courses do 

          desc "Returns list of all courses"
          get do
            school.courses
          end

          desc "Returns a specific course"
          get ":id" do 
            course
          end

          desc "Updates a specific course's attributes"
          put ":id" do
            @course = course
            if @course.update_attributes(declared_params)
              return @course
            else
              return "There was an error updating the tutor: #{@course.errors.full_messages}"
            end
          end

        end
      end
    end
  end
end