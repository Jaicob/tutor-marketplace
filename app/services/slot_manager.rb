class SlotManager

  # sm = SlotManager.new(tutor_id: 1, original_start_time: '2015-08-01 12:00:00', original_duration: 2, new_start_time: '2015-08-02 11:00:00', new_duration: '3')

  attr_accessor :tutor, :original_start_time, :original_duration, :new_start_time, :new_duration, :slots

  def initialize(params)
    # ex. params = (
    #   tutor_id: 1, 
    #   original_start_time: '2015-08-01 12:00:00', 
    #   original_duration: '2015-08-01 16:00:00', 
    #   new_start_time: '2015-08-02 11:00:00', 
    #   new_duration: '2015-08-02 12:00:00'
    # )

    # Required
    @tutor = Tutor.find(params[:tutor_id]) 
    
    @original_start_time = params[:original_start_time].to_datetime
    @original_duration = params[:original_duration]
    
    @new_start_time = params[:new_start_time].to_datetime
    @new_duration = params[:new_duration]

    # Calculated
    @start_adjustment = @new_start_time.to_time - @original_start_time.to_time #result is in seconds    
    @original_start_DOW_time = @original_start_time.strftime('%a %T') # Used for finding slots by weekday and time
  end

  # Lazy load the slots for the range
  def get_slots_for_range
    @slots = []
    @tutor.slots.each do |slot|
      @slot_start_DOW_time = slot.start_time.strftime('%a %T')
      @slot_duration = slot.duration
        
      if @slot_start_DOW_time == @original_start_DOW_time && @slot_duration == @original_duration
        @slots << slot
      end
    end
    @slots
  end

  # Load slots and update all that match the range
  def update_slots
    get_slots_for_range
    @slots.each do |slot|
      slot.start_time = slot.start_time + @start_adjustment.seconds
      slot.duration = @new_duration
      slot.save
    end
    @slots
  end

  # Destroy all sots that match the range
  def destroy_slots
    get_slots_for_range
    @slot_ids = []
    @slots.each do |slot|
      @slot_ids << slot.id
      slot.destroy 
    end
    @slot_ids
  end

end