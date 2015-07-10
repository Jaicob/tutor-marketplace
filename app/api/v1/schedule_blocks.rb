module V1
  class ScheduleBlocks < Grape::API

    include V1::Defaults

    # This section makes calls to schedule blocks in the context of tutors
    resource :tutors do 
      segment "/:tutor_id" do
        resource :schedule_blocks do 

          helpers do 
            def tutor
              Tutor.find(params[:tutor_id])
            end
          end

          params do
            requires :schedule_block, type: Hash do 
              requires :date, type: Date
            end
          end

          desc "Returns all schedule_blocks for a tutor"
          get do 
            tutor.schedule_blocks
          end

          desc "Returns a specific schedule_block for a tutor"
          get ":id" do 
            tutor.schedule_blocks.find(params[:id])
          end

          desc "Creates a schedule_block for a tutor" 
          post do
            schedule_block = ScheduleBlock.new(declared(params))
            if schedule_block.save
              return schedule_block
            else
              return "Schedule block could not be saved: #{@schedule_block.errors.full_messages}"
            end
          end

          # Updates with PATCH
          desc "Updates a schedule_block for a tutor"
          patch ":id" do
            @schedule_block = tutor.schedule_blocks.find(params[:id])
            puts "DECLARED PARAMS = #{declared(params).to_s}"
            @schedule_block.update_attributes(declared(params))
            if @schedule_block.save
              return @schedule_block
            else
              return "Schedule block could not be updated: #{@schedule_block.errors.full_messages}"
            end
          end

          # Updates with PUT
          desc "Updates a schedule_block for a tutor"
          put ":id" do
            { "declared_params" => declared(params) }
          end

          desc "Deletes a schedule_block for a tutor"
          delete ":id" do 
            @schedule_block = tutor.schedule_blocks.find(params[:id])
            if @schedule_block.destroy
              return "Schedule block succesfully deleted."
            else
              return "Schedule block was not deleted."
            end
          end





         


        end
      end
    end
  end
end


#  date            :date
#  start_time      :time
#  end_time        :time
#  status          :integer          default(0)
#  reservaton_min  :integer
#  reservation_max :integer


# module V1
#   class ScheduleBlocks < Grape::API

#     include V1::Defaults

#     # This section makes calls to schedule blocks in the context of tutors
#     resource :tutors do 
#       segment "/:tutor_id" do
#         resource :schedule_blocks do 

#           # Updates with PUT
#           desc "Updates a schedule_block for a tutor"
#           put ":id" do
#             { "declared_params" => declared(params) }
#           end

#           # A tutor has_many :schedule_blocks

#           # Schedule Block Attributes
#           #  date            :date
#           #  start_time      :time
#           #  end_time        :time
#           #  status          :integer          default(0)
#           #  reservaton_min  :integer
#           #  reservation_max :integer

#           params do
#             requires :schedule_block, type: Hash do 
#               optional :date, type: Date
#               optional :start_time, type: Time
#               optional :end_time, type: Time 
#               optional :status, type: Integer 
#               optional :reservation_min, type: Integer 
#               optional :reservation_max, type: Integer
#             end
#           end
#         end
#       end
#     end
#   end
# end





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