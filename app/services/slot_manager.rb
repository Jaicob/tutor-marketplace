class SlotManager
  # DateTime.now.strftime("%a %T") formatted date
  # sm = SlotManager.new start_time: "2015-08-29 17:00:16", end_time: "2015-08-29 19:00:16", new_start_time: "2015-08-29 17:00:16", new_end_ti> "2015-08-29 19:00:16", new_start_time: "2015-08-29 17:00:16", new_end_time: "2015-08-29 21:00:16"
  # sm = SlotManager.new(tutor: 1, start_time: )
  def initialize(params)
    @tutor = Tutor.find(params[:tutor_id]) 
    # @start_date = params[:start_date] # May not need this and end_date 
    # @end_date = params[:end_date]
    @start_time = params[:start_time].to_datetime
    @end_time = params[:end_time].to_datetime
    @new_start_time = params[:new_start_time].to_datetime
    @new_end_time = params[:new_end_time].to_datetime
    @start_adjustment = @new_start_time.to_time - @start_time.to_time #result is in seconds
    @end_adjustment = @new_end_time.to_time - @end_time.to_time #result is in seconds 

    @start_week_time = @start_time.strftime('%a %T')
    @end_week_time = @end_time.strftime('%a %T')

  end

  # Lazy load the slots for the range
  #Nothing is coming back here right now
  def get_slots_for_range
    @slots = @tutor.slots.where(start_week_time: @start_week_time).where(end_week_time: @end_week_time)
  end

  # Load slots and update all that match the range
  def update_slots
    get_slots_for_range
    puts "SLOTS BEFORE"
    puts @slots.inspect
    @slots.each do |slot|
      puts "updating time"
      slot.start_time = slot.start_time + @start_adjustment.seconds
      slot.end_time = slot.end_time + @end_adjustment.seconds
      slot.update_week_times
      slot.save
      # slot.update_attributes(start_time: new_start_time, end_time: new_end_time)
    end

    puts "SLOTS AFTER"
    puts @slots
    @slots
    
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