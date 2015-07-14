module V1
  class Slots < Grape::API

    include V1::Defaults

    # This section makes calls to schedule blocks in the context of tutors
    resource :tutors do 
      segment "/:tutor_id" do
        resource :slots do 

          helpers do 
            def tutor
              Tutor.find(params[:tutor_id])
            end
          end

          desc "Returns all slots for a tutor"
          get do 
            tutor.slots
          end

          desc "Returns a specific slot for a tutor"
          get ":id" do 
            tutor.slots.find(params[:id])
          end

          desc "Creates a single slot for a tutor" 
          post do
            slot = Slot.new(params)
            if slot.save
              return slot
            else
              return "Schedule block could not be saved: #{@slot.errors.full_messages}"
            end
          end

          desc "Creates a re-occuring slot for a tutor"
          post "/regular" do
            slot = Slot.new
          end


          # Updates with PATCH
          desc "Updates a slot for a tutor"
          patch ":id" do
            @slot = tutor.slots.find(params[:id])
            puts "DECLARED PARAMS = #{declared(params).to_s}"
            @slot.update_attributes(params)

            if @slot.save
              return @slot
            else
              return "Schedule block could not be updated: #{@slot.errors.full_messages}"
            end
          end

          # Updates with PUT
          desc "Updates a slot for a tutor"
          put ":id" do
            @slot = tutor.slots.find(params[:id])
            puts "DECLARED PARAMS = #{declared(params).to_s}"
            @slot.update_attributes(params)

            if @slot.save
              return @slot
            else
              return "Schedule block could not be updated: #{@slot.errors.full_messages}"
            end
          end

          desc "Deletes a slot for a tutor"
          delete ":id" do 
            @slot = tutor.slots.find(params[:id])
            if @slot.destroy
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
      #   requires :slot, type: Hash do 
      #     optional :date, type: Date
      #     optional :start_time, type: Time
      #     optional :end_time, type: Time 
      #     optional :status, type: Integer 
      #     optional :reservation_min, type: Integer 
      #     optional :reservation_max, type: Integer
      #   end
      # end