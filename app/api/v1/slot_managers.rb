module V1
  class SlotManagers < Grape::API

    include V1::Defaults

      helpers do 

        def tutor
          Tutor.find(params[:tutor_id])
        end

        def slot_manager
          SlotManager.find(params[:id])
        end

      end

      params do 
        optional  :id,              type: Integer     
        optional  :tutor_id,        type: Integer
        optional  :start_date,      type: String
        optional  :end_date,        type: String
        optional  :start_time,      type: String
        optional  :end_time,        type: String
        optional  :is_recurring,    type: Integer
        optional  :exlcusions,      type: Hash
      end

    #
    # SlotManagers 
    # /slot_managers
    #

    resource :slot_managers do 
      desc "Returns all slot_managers"
      get do 
        SlotManager.all
      end

      desc "Returns a specific slot"
      get ":id" do 
        slot_manager
      end

      desc "Updates a specific slot"
      patch ":id" do
        @slot_manager = slot_manager
        if @slot_manager.update_attributes(declared_params)
          return @slot_manager
        else
          return "Slot manager could not be saved: #{@slot_manager.errors.full_messages}"
        end
      end
    end

    #
    # SlotManagers by Tutor
    # /tutors/:tutor_id/slot_managers
    #

      params do 
        optional  :id,              type: Integer     
        optional  :tutor_id,        type: Integer
        optional  :start_date,      type: String
        optional  :end_date,        type: String
        optional  :start_time,      type: String
        optional  :end_time,        type: String
        optional  :is_recurring,    type: Integer
        optional  :exlcusions,      type: Hash
      end

    resource :tutors do
      segment "/:tutor_id" do
        resource :slot_managers do 

          desc "Returns all slot_managers for a tutor"
          get do 
            tutor.slot_managers
          end

          desc "Returns a slot_manager for a tutor"
          get ":id" do 
            slot_manager
          end

          desc "Creates a slot_manager for a tutor" 
          post do
            @slot_manager = SlotManager.create(declared_params)
            if @slot_manager.save
              @slot_manager.create_regular_slots
              return @slot_manager
            else
              return "Slot manager could not be saved: #{@slot_manager.errors.full_messages}"
            end
          end

          # Updates with PATCH
          desc "Updates a slot_manager for a tutor"
          patch ":id" do
            @slot_manager = slot_manager
            @slot_manager.update_attributes(declared_params)
            
            if @slot_manager.save
              return @slot_manager
            else
              return "Slot manager could not be updated: #{@slot_manager.errors.full_messages}"
            end
          end

          # Updates with PUT
          desc "Updates a slot_manager for a tutor"
          put ":id" do
            @slot_manager = slot_manager
            @slot_manager.update_attributes(declared_params)
            @slot_manager.update_slots(declared_params)

            if @slot_manager.save
              return @slot_manager
            else
              return "Slot manager could not be updated: #{@slot_manager.errors.full_messages}"
            end
          end

          desc "Deletes a slot_manager for a tutor"
          delete ":id" do 
            @slot_manager = slot_manager

            if @slot_manager.destroy
              return "Slot manager was succesfully deleted."
            else
              return "Slot manager was not deleted: #{@slot_manager.errors.full_messages}"
            end
          end    
        end
      end
    end
  end
end
