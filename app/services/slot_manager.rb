class SlotManager

  # sm = SlotManager.new(tutor: 1, start_time: )
  def initialize(params)
    @tutor = params[:tutor_id] 
    # @start_date = params[:start_date] # May not need this and end_date 
    # @end_date = params[:end_date]
    @start_time = params[:start_time]
    @end_time = params[:end_time]
  end

  # Lazy load the slots for the range
  def get_slots_for_range
    @slots = @tutor.slots.where(start_time: @start_time).where(end_time: @end_time)
  end

  # Load slots and update all that match the range
  def update_slots
    get_slots_for_range
    @slots.update_all(start_time: @start_time, end_time: @end_time)
  end

  # Destroy all sots that match the range
  def destroy_slots
    get_slots_for_range
    @slots.destroy_all(start_time: @start_time, end_time: @end_time)
  end

end