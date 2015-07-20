class SlotManager

  # sm = SlotManager.new(tutor_id: 5, start_dow_time: "Sat 17:00:00", end_dow_time: "Sat 19:00:00")

  attr_accessor :tutor, :start_dow_time, :end_dow_time, :slots

  def initialize(params) # params = (tutor_id: 1, start_dow_time: "Sat 10:00", end_dow_time: "Sat 12:00")
    @tutor = Tutor.find(params[:tutor_id]) 
    @start_dow_time = params[:start_dow_time]
    @end_dow_time = params[:end_dow_time]

    @slots = []

    @tutor.slots.each do |slot|

      @slot_start_dow_time = slot.start_time.strftime('%a %T')
      @slot_end_dow_time = slot.end_time.strftime('%a %T')

      if @start_dow_time == @slot_start_dow_time && @end_dow_time == @slot_end_dow_time
        @slots << slot
      end
    end
  end

  def update_slots(params) # params = (new_start_time: "", new_end_time: "Fri 16:00:00")
    slots.each do |slot|

      slot.update_attributes(params)
      # slot.start_time = slot.start_time + @start_adjustment.seconds
      # slot.end_time = slot.end_time + @end_adjustment.seconds
      # slot.update_week_times
      # slot.save
      slot.save
    end
    slots
  end

  # Destroy all sots that match the range
  def destroy_slots
    @slots.destroy_all
  end

end