class API::V1::SlotsController < API::V1::Defaults
  before_action :set_tutor
  before_action :restrict_to_resource_owner, except: [:index]
  before_action :set_slot, only: [:show, :update, :destroy]

  def index
    @slots = @tutor.slots
    @slots_array = []
    @slots.map do |slot|
      # can't add non-attribute 'unavailable_times' to object, so converting slot to hash of attributes instead
      slot_hash = slot.attributes
      slot_hash['unavailable_times'] = slot.appointments.map { |appt| appt.start_time }
      @slots_array << slot_hash
    end
    respond_with(@slots_array)
  end

  def show
    respond_with(@slot)
  end

  def create
    slot_creator = SlotCreator.new(safe_params) 
    @slots = slot_creator.create_slots
    if @slots
       render json: @slots, status: 200
    else
      render json: @slots.errors.full_messages
    end
  end

  def update # one slot only - does NOT use SlotManager
    if @slot.update(safe_params)
      render json: @slot, status: 200
    else
      render json: @slot.errors.full_messages
    end
  end

  def update_slot_group # multiple slots - uses SlotManager
    slot_manager = SlotManager.new(safe_params)
    @slots = slot_manager.update_slots    
    if @slots
      render json: @slots, status: 200
    else
      render json: @slots.errors.full_messages
    end
  end

  def destroy_slot_group # one or multiple slots - uses SlotManager
    slot_manager = SlotManager.new(safe_params)
    @slot_ids = slot_manager.destroy_slots
    render json: @slot_ids
  end

  private

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

    def set_slot
      @slot = Slot.find(params[:id])
    end

    def restrict_to_resource_owner
      if current_user.nil? || current_user.tutor != @tutor
        return redirect_to restricted_access_path, status: 401
      end
    end

    def safe_params
      hash = {}
      hash[:tutor_id] = params[:tutor_id] if params[:tutor_id]
      hash[:status] = params[:status] if params[:status]
      hash[:slot_type] = params[:slot_type] if params[:slot_type]
      hash[:start_time] = params[:start_time] if params[:start_time]
      hash[:duration] = params[:duration] if params[:duration]
      hash[:weeks_to_repeat] = params[:weeks_to_repeat] if params[:weeks_to_repeat]
      hash[:reservation_min] = params[:reservation_min] if params[:reservation_min]
      hash[:reservation_max] = params[:reservation_max] if params[:reservation_max]

      hash[:original_start_time] = params[:original_start_time] if params[:original_start_time]
      hash[:original_duration] = params[:original_duration] if params[:original_duration]
      hash[:new_start_time] = params[:new_start_time] if params[:new_start_time]
      hash[:new_duration] = params[:new_duration] if params[:new_duration]
      return hash
    end 

end