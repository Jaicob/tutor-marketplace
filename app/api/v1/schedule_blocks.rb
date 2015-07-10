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
            schedule_block = ScheduleBlock.new(params)
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
            @schedule_block.update_attributes(params)

            if @schedule_block.save
              return @schedule_block
            else
              return "Schedule block could not be updated: #{@schedule_block.errors.full_messages}"
            end
          end

          # Updates with PUT
          desc "Updates a schedule_block for a tutor"
          put ":id" do
            @schedule_block = tutor.schedule_blocks.find(params[:id])
            puts "DECLARED PARAMS = #{declared(params).to_s}"
            @schedule_block.update_attributes(params)

            if @schedule_block.save
              return @schedule_block
            else
              return "Schedule block could not be updated: #{@schedule_block.errors.full_messages}"
            end
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

      # Need to figure out how to work with declared(params)

      # params do
      #   requires :schedule_block, type: Hash do 
      #     optional :date, type: Date
      #     optional :start_time, type: Time
      #     optional :end_time, type: Time 
      #     optional :status, type: Integer 
      #     optional :reservation_min, type: Integer 
      #     optional :reservation_max, type: Integer
      #   end
      # end
