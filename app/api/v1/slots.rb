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

        def slot_manager
          SlotManager.find(params[:slot_manager_id])
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

#
# Slots
# /slots
#
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

#
# Slots by Tutor 
# /tutors/:tutor_id/slots
#
    resource :tutors do
      segment "/:tutor_id" do
        resource :slots do 

          desc "Returns all slots for a tutor"
          get do 
            tutor.slots
          end

          desc "Returns a specific slot for a tutor"
          get ":id" do 
            tutor.slots.find(params[:id])
          end

          # Slots should not be created on their own!
          # Even for a single one-off slot, it should be created through a slot_manager
          # If the start_date and end_date for a slot are the same (or technically less than
          # a week apart) then no repeating slots will be created and it will be a slot_manager
          # with a single slot
          #
          # Removed the following endpoint because of this...(read above)
          #
          # desc "Creates a single slot for a tutor" 
          # post do
          #   @slot = Slot.create(declared_params)
          #   if @slot.save
          #     return @slot
          #   else
          #     return "Slot could not be saved: #{@slot.errors.full_messages}"
          #   end
          # end

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

          # 
          # I don't think we want to allow slots to be deleted. They should be blocked instead
          # which can be done by updating them.
          #
          # desc "Deletes a slot for a tutor"
          # delete ":id" do 
          #   @slot = tutor.slots.find(params[:id])
          #   if @slot.destroy
          #     return "Slot succesfully deleted."
          #   else
          #     return "Slot was not deleted: #{@slot.errors.full_messages}"
          #   end
          # end
        end
      end
    end


#
# Slots by Tutor and SlotManager
# /tutors/:tutor_id/slot_managers/:slot_manager_id/slots
#
    helpers do 
      def slot
        Slot.find(params[:id])
      end
    end

    resource :tutors do
      segment "/:tutor_id" do
        resource :slot_managers do 
          segment "/:slot_manager_id" do 
            resource :slots do 

              desc "Returns all of a slot managers' slots"
              get do 
                slot_manager.slots
              end

              desc "Returns a single slot of a slot_manager"
              get ":id" do
                slot
              end

              desc "Updates a single slot of a slot_manager"
              put ":id" do
                # slot
              end
            end
          end
        end
      end
    end
  end
end