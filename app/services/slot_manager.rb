class SlotManager

  def initialize(params)
    @tutor = params[:tutor_id] 
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @start_time = params[:start_time]
    @end_time = params[:end_time]
  end

  # Lazy load the slots for the range
  def get_slots_for_range(params)
    @slots = tutor.slots.where(start_time: @start_time).where(end_time: @end_time)
  end

  def update_slots(params)
    get_slots_for_range
    @slots.update_all(start_time: params[:start_time], end_time: params[:end_time])
  end

  def destroy_slots

  end

end