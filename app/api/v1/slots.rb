module V1
  class Slots < Grape::API

    include V1::Defaults

      helpers do 
        def slot
          Slot.find(params[:id])
        end

        def tutor
          Tutor.find(params[:tutor_id])
        end
      end

      params do 
        optional  :id,                  type: Integer 
        optional  :tutor_id,            type: Integer

        # params for SlotCreators
        optional  :status,              type: Integer  
        optional  :start_time,          type: String
        optional  :duration,            type: Integer
        optional  :weeks_to_repeat,     type: Integer
        optional  :reservation_min,     type: Integer
        optional  :reservation_max,     type: Integer

        # Params for SlotManagers
        optional  :original_start_time, type: String
        optional  :original_duration,   type: Integer
        optional  :new_start_time,      type: String
        optional  :new_duration,        type: Integer
      end
      

    resource :tutors do
      segment "/:tutor_id" do
        resource :slots do 

          desc "Returns all slots for a tutor"
          get do 
            tutor.slots
          end

          desc "Returns a slot for a tutor"
          get ":id" do 
            tutor.slots.find(params[:id])
          end

          desc "Creates one or many slots for a tutor" # depends on the date range given
          post do
            slot_creator = SlotCreator.new(declared_params) 
            @slots = slot_creator.create_slots
            if @slots 
              return @slots
            else
              return "Slot could not be saved: #{@slot.errors.full_messages}"
            end
          end

          # Update all slots for a range
          desc "Updates all slots for a tutor" 
          put do
            slot_manager = SlotManager.new(declared_params) 
            @slots = slot_manager.update_slots 
            if @slots 
              return @slots
            else
              return "Slot could not be updated: #{@slot.errors.full_messages}"
            end
          end

          # Destroy all slots for a range
          desc "Destroys all slots for a tutor" 
          delete do
            slot_manager = SlotManager.new(declared_params) 
            @slots = slot_manager.destroy_slots 
            if @slots 
              return @slots
            else
              return "Slot could not be destroyed: #{@slot.errors.full_messages}"
            end
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