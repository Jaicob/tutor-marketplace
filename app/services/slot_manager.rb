class SlotManager

  ## For easy creation for testing in console
  # sc = SlotCreator.new(tutor_id: 1, start_time: '2015-08-01 12:00', duration: 3600, weeks_to_repeat: 10)
  # sm = SlotManager.new(tutor_id: 1, original_start_time: '2015-08-01 12:00:00', original_duration: 3600, new_start_time: '2015-08-02 11:00:00', new_duration: '7200')

  attr_accessor :tutor, :original_start_time, :original_duration, :new_start_time, :new_duration, :slots

  def initialize(params)
    # ex. params = (
    #   tutor_id: 1,
    #   original_start_time: '2015-08-01 12:00:00',
    #   original_duration: '3600',
    #   new_start_time: '2015-08-02 11:00:00',
    #   new_duration: '7200'
    # )

    # Required
    @tutor = Tutor.find(params[:tutor_id])
    @school = @tutor.school

    @original_start_time = DateTime.iso8601(params[:original_start_time])#params[:original_start_time].to_datetime # DateTime.iso8601(params[:start_time])
    @original_duration = params[:original_duration]

    @new_start_time = params[:new_start_time].to_datetime if params[:new_start_time]
    @new_duration = params[:new_duration] if params[:new_duration]

    # Calculated
    if @new_start_time
      @start_adjustment = @new_start_time.to_time - @original_start_time.to_time # result is in seconds
    end
    @original_start_DOW_time = @original_start_time.strftime('%a %T') # Used for finding slots by weekday and time
  end

  # Lazy load the slots for the range
  # should probably use find_each here too
  def get_slots_for_range
    @slots = []
    @tutor.slots.each do |slot|
      @slot_start_DOW_time = slot.start_time.strftime('%a %T')
      @slot_duration = slot.duration
      puts @slot_start_DOW_time
      puts @original_start_DOW_time
      puts @slot_start_DOW_time == @original_start_DOW_time
      puts @slot_duration == @original_duration.to_i
      if @slot_start_DOW_time == @original_start_DOW_time && @slot_duration == @original_duration.to_i
        @slots << slot
      end
    end
    return @slots
  end

  # Load slots and update all that match the range
  # might want to try find_each here to speed things up
  def update_slots
    @slots = get_slots_for_range
    @slots.each do |slot|
      slot.start_time = slot.start_time + @start_adjustment.seconds
      slot.duration = @new_duration
      slot.save
    end
    return @slots
  end

  # Destroy all slots that match the range
  def destroy_slots
    @slots = get_slots_for_range
    @slot_ids = []
    @slots.each do |slot|
      if slot.appointments.empty? || slot.appointments.where(status: 0).empty?
        @slot_ids << slot
        slot.destroy
      end
    end
    @slot_ids
  end

end