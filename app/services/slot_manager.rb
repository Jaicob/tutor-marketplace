class SlotManager

  def initialize(params)
    # Required
    @tutor = Tutor.find(params[:tutor_id]) 
    @start_time = params[:start_time].to_datetime # the original start_time
    @end_time = params[:end_time].to_datetime # the original end_time
    @new_start_time = params[:new_start_time].to_datetime
    @new_end_time = params[:new_end_time].to_datetime 

    # Calculated
    @start_adjustment = @new_start_time.to_time - @start_time.to_time #result is in seconds
    @end_adjustment = @new_end_time.to_time - @end_time.to_time #result is in seconds 
    @start_week_time = @start_time.strftime('%a %T') # Used for finding slots by weekday and time
    @end_week_time = @end_time.strftime('%a %T') # Used for finding slots by weekday and time
  end

  # Lazy load the slots for the range
  def get_slots_for_range
    @slots = @tutor.slots.where(start_week_time: @start_week_time).where(end_week_time: @end_week_time)
  end

  # Load slots and update all that match the range
  def update_slots
    get_slots_for_range
    @slots.each do |slot|
      puts "updating time"
      slot.start_time = slot.start_time + @start_adjustment.seconds
      slot.end_time = slot.end_time + @end_adjustment.seconds
      slot.update_week_times
      slot.save
    end
    @slots
    
    # Attempts at update_all queries, this way would be far more effecient
    # @slots.update_all(start_time: @new_start_time, end_time: @new_end_time)  start_time = start_time + #{start_adjustment.seconds} , 
    # @slots.update_all(start_time: start_time + start_adjustment.seconds, end_time: end_time + end_adjustment.seconds) 
    # @slots.update_all("end_time = end_time + #{end_adjustment.seconds}") 
    # @slots.update_all(end_time: (end_time: + end_adjustment))
    # @slots.update_all(["end_time = end_time + #{:end_adjustment}.seconds", {end_adjustment: 7200}])
  end

  # Destroy all sots that match the range
  def destroy_slots
    get_slots_for_range
    @slots.destroy_all
  end

end