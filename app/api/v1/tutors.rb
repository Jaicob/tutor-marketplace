module V1
  class Tutors < Grape::API

    include V1::Defaults

    helpers do 
    end

    resource :tutors do 


      helpers do 
        def tutor
          Tutor.find(params[:id])
        end

        def tutor_course
          TutorCourse.find(params[:tutor_course_id])
        end 
      end

      desc "Returns list of all tutors"
      get do
        Tutor.all.as_json
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


      segment "/:id" do # nested /tutors/:id


        resource :courses do # this refers to TutorCourses not simply Courses

          desc "Returns all tutor_course for a tutor"
          get do 
            tutor.tutor_courses
          end

          desc "Returns one of a tutor's tutor_courses"
          get ":tutor_course_id" do
            TutorCourse.find(params[:tutor_course_id])
          end

        end

        # resource :slots do 

        #   desc "Returns all slots for a tutor"
        #   get do
        #     tutor.slots_by_slot_manager
        #   end

        #   desc "Returns one of a tutor's slots"
        #   get ":slot_id" do
        #     Slot.find(params[:slot_id])
        #   end
        # end


# When a tutor creates a slot, they have to choose whether it's repeating or whether it's a one-off.
# But, we are assuming that everything defaults to repeating and extends to the end of the semester right now.
# So we can assume all slot_managers will have:
#     is_reccuring = true 
#     end_date = December 16, 2015
# So the only things to be set are:
#     start_date = Day that is selected on Full Calendar that will be sent back as start_date
#
#
      end
    end
  end
end