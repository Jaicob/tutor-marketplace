class SlotCreator

  attr_accessor :tutor, :start_time, :duration, :weeks_to_repeat, :start_date, :end_date, :slots

  def initialize(params)
     # ex. params = (
     #    tutor_id:         1, 
     #    start_time:       '2015-08-01 17:00', 
     #    duration:         3600, 
     #    weeks_to_repeat:  1
     # )
     
    @tutor = Tutor.find(params[:tutor_id])
    @start_time = params[:start_time].to_datetime
    @duration = params[:duration]
    @weeks_to_repeat = (params[:weeks_to_repeat] || 1).to_i

    @start_date = @start_time.to_date
    @end_date = @start_date + (@weeks_to_repeat * 7)
  end 

  # Creates one or more slots with the start_time and duration based on how many weeks_to_repeat
  def create_slots
    date = @start_date
    @slots = []
    while date < @end_date
      @slots << @tutor.slots.create(start_time: @start_time, duration: @duration)
      date = date + 7
      @start_time = @start_time + 7
    end
    @slots
  end

end

# sc = SlotCreator.new(tutor_id: 1, start_time: '2015-08-01 17:00', duration: 2, weeks_to_repeat: 1)