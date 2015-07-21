class AlternateSlotManager

  # IMPORTANT - start_dow_time and end_dow_time must contain seconds to work correctly
  # OK - "Sat 12:00:00"
  # WON'T WORK - "Sat 12:00"

  # Times below correspond to times of seed slots for all Tutors
  # sm = SlotManager.new(tutor_id: 1, start_dow_time: "Sat 12:00:00", end_dow_time: "Sat 16:00:00")

  # Above DOW times in Datetime format
  #     start_time: "2015-08-01 12:00:00", 
  #     end_time: "2015-08-01 16:00:00"

  attr_accessor :tutor, :start_dow_time, :end_dow_time, :slots, :new_start_dow_time, :new_end_dow_time

  def initialize(params) 
     # params = (
     #  tutor_id: 1, 
     #  start_dow_time: "Sat 10:00", 
     #  end_dow_time: "Sat 12:00"
     #  )

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

  # sm.update_slots(new_start_time: "2015-08-01 13:00:00", new_end_time: "2015-08-01 15:00:00")
  
  def update_slots(params) 
    # params = (
    #   new_start_time: '2015-08-02 10:00', 
    #   new_end_time: '2015-08-02 14:00'
    #   )

    @new_start_time = params[:new_start_time]
    @new_end_time = params[:new_end_time]
    # @new_start_dow_time = @new_start_time.to_datetime.strftime('%a %T')
    # @new_end_dow_time = @new_end_time.to_datetime.strftime('%a %T')

    puts "New start time = #{@new_start_time}"
    puts "New end time = #{@new_end_time}"
    puts "New start DOW time = #{@new_start_dow_time}"
    puts "New end DOW time = #{@new_end_dow_time}"
    puts "Old start DOW time = #{@start_dow_time}"
    puts "Old end DOW time = #{@end_dow_time}"

    # New start time =      2015-08-01 13:00:00
    # New end time =        2015-08-01 15:00:00
    # New start DOW time =  Sat 13:00:00
    # New end DOW time =    Sat 15:00:00
    # Old start DOW time =  Sat 12:00:00
    # Old end DOW time =    Sat 16:00:00

    # @slots.each do |slot
    #   slot.updates_attributes(start_time: , end_time: )
    # end
    # @slots
  end

    # @start_adjustment = @new_start_time.to_time - @start_time.to_time #result is in seconds
    # @end_adjustment = @new_end_time.to_time - @end_time.to_time #result is in seconds 
    # @start_week_time = @start_time.strftime('%a %T') # Used for finding slots by weekday and time
    # @end_week_time = @end_time.strftime('%a %T') # Used for finding slots by weekday and time

  # attr_accessor :tutor, :start_time, :end_time, :weeks_to_repeat, :start_date, :end_date, :slots

  # def initialize(params)
  #    # ex. params = (
  #    #    tutor_id:         1, 
  #    #    start_time:       '2015-08-01 17:00', 
  #    #    end_time:         '2015-08-01 20:00', 
  #    #    weeks_to_repeat:  1
  #    #  )
  #   @tutor = Tutor.find(params[:tutor_id])
  #   @start_time = params[:start_time].to_datetime
  #   @end_time = params[:end_time].to_datetime
  #   @weeks_to_repeat = params[:weeks_to_repeat].to_i

  #   @start_date = @start_time.to_date
  #   @end_date = @start_date + (@weeks_to_repeat * 7)
  # end 

  # # Creates one or more slots with the start_time and end_time based on how many weeks_to_repeat
  # def create_slots
  #   date = @start_date
  #   @slots = []
  #   while date < @end_date
  #     @slots << @tutor.slots.create(start_time: @start_time, end_time: @end_time)
  #     date = date + 7
  #     @start_time = @start_time + 7
  #     @end_time = @end_time + 7
  #   end
  #   @slots
  # end


  def destroy_slots
    @slots.destroy_all
  end

end


  # sm = SlotManager.new(tutor_id: 1, start_time: '2015-08-01 12:00:00', end_time: '2015-08-01 16:00:00', new_start_time: '2015-08-02 11:00:00', new_end_time: '2015-08-02 12:00:00')
  
  @start_adjustment = @new_start_time.to_time - @start_time.to_time #result is in seconds

  start_time = '2015-08-01 12:00:00'.to_time
  new_start_time = '2015-08-02 11:00:00'.to_time




