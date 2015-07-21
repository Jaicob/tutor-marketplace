class SlotManager

  # sm = SlotManager.new(tutor_id: 1, original_start_time: '2015-08-01 12:00:00', original_end_time: '2015-08-01 16:00:00', new_start_time: '2015-08-02 11:00:00', new_end_time: '2015-08-02 12:00:00')

  attr_accessor :tutor, :original_start_time, :original_end_time, :new_start_time, :new_end_time, :slots

  def initialize(params)
    # Required
    @tutor = Tutor.find(params[:tutor_id]) 
    
    @original_start_time = params[:original_start_time].to_datetime # the original start_time
    @original_end_time = params[:original_end_time].to_datetime # the original end_time
    
    @new_start_time = params[:new_start_time].to_datetime
    @new_end_time = params[:new_end_time].to_datetime 

    # Calculated
    @start_adjustment = @new_start_time.to_time - @original_start_time.to_time #result is in seconds
    @end_adjustment = @new_end_time.to_time - @original_end_time.to_time #result is in seconds 
    
    @original_start_DOW_time = @original_start_time.strftime('%a %T') # Used for finding slots by weekday and time
    @original_end_DOW_time = @original_end_time.strftime('%a %T') # Used for finding slots by weekday and time
  end

  # Lazy load the slots for the range
  def get_slots_for_range
    # @slots = @tutor.slots.where(start_week_time: @start_week_time).where(end_week_time: @end_week_time)
    @slots = []
    @tutor.slots.each do |slot|
     
      @slot_start_DOW_time = slot.start_time.strftime('%a %T')
      @slot_end_DOW_time = slot.end_time.strftime('%a %T')
      
      if @slot_start_DOW_time == @original_start_DOW_time && @slot_end_DOW_time == @original_end_DOW_time
        @slots << slot
      end
    end
    @slots
  end

  # Load slots and update all that match the range
  def update_slots
    get_slots_for_range
    @slots.each do |slot|
      puts "updating time"
      slot.start_time = slot.start_time + @start_adjustment.seconds
      slot.end_time = slot.end_time + @end_adjustment.seconds
      slot.save
    end
    @slots
  end

  # Destroy all sots that match the range
  def destroy_slots
    get_slots_for_range
    @slots.destroy_all
  end

end