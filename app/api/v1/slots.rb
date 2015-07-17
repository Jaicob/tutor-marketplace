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
        optional  :id,              type: Integer     
        optional  :status,          type: Integer  
        optional  :start_time,      type: String
        optional  :end_time,        type: String
        optional  :reservation_min, type: Integer
        optional  :reservation_max, type: Integer
        optional  :tutor_id,        type: Integer
        optional  :start_date,      type: String
        optional  :end_date,        type: String
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
            slot_creator.create_slots
            # if @slot_creator.create_slots
            #   return @slot
            # else
            #   return "Slot could not be saved: #{@slot.errors.full_messages}"
            # end
          end

  # def initialize(params)
  #   @tutor = params[:tutor_id] 
  #   @start_date = params[:start_date].to_date
  #   @end_date = params[:end_date].to_date
  #   @start_time = params[:start_time].to_date
  #   @end_time = params[:end_time].to_date
  # end 

  # def create_slots
  #   date = @start_date
  #   while date < @end_date
  #     Slot.create(start_time: @start_time, end_time: @end_time)
  #     date = date + 7
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
