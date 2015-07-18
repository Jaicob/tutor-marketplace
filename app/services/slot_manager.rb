class SlotManager
  # DateTime.now.strftime("%a %T") formatted date
  # sm = SlotManager.new(tutor: 1, start_time: )
  def initialize(params)
    @tutor = Tutor.find(params[:tutor_id]) 
    # @start_date = params[:start_date] # May not need this and end_date 
    # @end_date = params[:end_date]
    @start_time = params[:start_time].to_datetime.strftime('%a %T')
    @end_time = params[:end_time].to_datetime.strftime('%a %T')
    @new_start_time = params[:new_start_time].to_datetime
    @new_end_time = params[:new_end_time].to_datetime
  end

  # Lazy load the slots for the range
  #Nothing is coming back here right now
  def get_slots_for_range
    @slots = @tutor.slots.where(start_week_time: @start_time).where(end_week_time: @end_time)
  end

  # Load slots and update all that match the range
  def update_slots
    get_slots_for_range
    @slots.update_all(start_time: @new_start_time, end_time: @new_end_time)
  end

  # Destroy all sots that match the range
  def destroy_slots
    get_slots_for_range
    @slots.destroy_all(start_week_time: @start_time, end_week_time: @end_time)
  end

end