module V1
  class ScheduleBlocks < Grape::API

    include V1::Defaults

    # This section makes calls to schedule blocks in the context of tutors
    resource :tutors do 
      segment "/:id" do
        resource :schedule_blocks do 

          desc "Returns all schedule_blocks for a tutor"
          get do 
            Tutor.find(params[:id]).schedule_blocks
          end

          desc "Creates a schedule_block for a tutor" 
          post do
            @schedule_block = ScheduleBlock.new(params)
            if @schedule_block.save
              return @schedule_block
            else
              return "Schedule block could not be saved: #{@schedule_block.errors.full_messages}"
            end
          end




        end
      end
    end
  end
end




# module V1
#   class Courses < Grape::API

#     include V1::Defaults

#     resource :courses do 
#       desc "Returns list of all courses"
#       get do
#         Course.all.as_json
#       end

#       desc "Returns a specific course"
#       get ":id" do 
#         Course.find(params[:id]).as_json
#       end

#       desc "Updates a specific course's attributes"
#       put ":id" do
#         @course = Course.find(params[:id])
#         if @course.update_attributes(params)
#           return @course.as_json
#         else
#           return "There was an error updating the tutor."
#         end
#       end
#     end
#   end
# end