module V1
  class Slots < Grape::API

    include V1::Defaults

      helpers do 
        def slot
          Slot.find(params[:id])
        end
      end

      params do 
        optional  :id,              type: Integer     
        optional  :slot_manager_id, type: Integer
        optional  :status,          type: Integer  
        optional  :start_time,      type: String
        optional  :end_time,        type: String
        optional  :reservation_min, type: Integer
        optional  :reservation_max, type: Integer
      end

    resource :slots do 
      desc "Returns all slots"
      get do 
        Slot.all
      end

      desc "Returns a specific slot"
      get ":id" do 
        slot
      end

      desc "Updates a specific slot"
      patch ":id" do
        @slot = slot
        if @slot.update_attributes(declared_params)
          return @slot
        else
          return "Slot could not be saved: #{@slot.errors.full_messages}"
        end
      end

    end 
    # End of resource: slots


      # Beggining of slots by tutor
      params do 
        optional  :id,              type: Integer     
        optional  :slot_manager_id, type: Integer
        optional  :status,          type: Integer  
        optional  :start_time,      type: String
        optional  :end_time,        type: String
        optional  :reservation_min, type: Integer
        optional  :reservation_max, type: Integer
      end

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
            @slot = Slot.create(declared_params)
            if @slot.save
              return @slot
            else
              return "Slot could not be saved: #{@slot.errors.full_messages}"
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
            @slot.update_attributes(declared_params)
            if @slot.save
              return @slot
            else
              return "Slot could not be updated: #{@slot.errors.full_messages}"
            end
          end

          # Updates with PUT
          desc "Updates a slot for a tutor"
          put ":id" do
            @slot = tutor.slots.find(params[:id])
            @slot.update_attributes(declared_params)

            if @slot.save
              return @slot
            else
              return "Slot could not be updated: #{@slot.errors.full_messages}"
            end
          end

          desc "Deletes a slot for a tutor"
          delete ":id" do 
            @slot = tutor.slots.find(params[:id])
            if @slot.destroy
              return "Slot succesfully deleted."
            else
              return "Slot was not deleted: #{@slot.errors.full_messages}"
            end
          end

        end
      end
    end
  end
end