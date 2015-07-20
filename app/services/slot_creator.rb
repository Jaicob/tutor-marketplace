class SlotCreator

  def initialize(params)
    @tutor = Tutor.find(params[:tutor_id])
    @start_date = params[:start_date].to_date
    @end_date = @start_date + (params[:weeks_to_repeat].to_i * 7)
    @start_time = params[:start_time].to_datetime
    @end_time = params[:end_time].to_datetime
  end 

  def create_slots
    date = @start_date
    slots = []
    while date < @end_date
      slots << @tutor.slots.create(start_time: @start_time, end_time: @end_time)
      date = date + 7
      @start_time = @start_time + 7
      @end_time = @end_time + 7
    end
    slots #AKA Time_Caves
  end

  # slot_date_range = @start_date .. @end_date.range.step(7)
  # slot_date_range.each do |slot_date|
  #   start_time = slot_date + Time.parse(@start_time)
  #   end_time = slot_date + Time.parse(@end_time)
  #   @tutor.slots.create(start_time: start_time, end_time: end_time)
  # end

end

# SlotCreator.new(tutor_id: 1, start_date: '2015-08-01', end_date: '2015-09-01', start_time: '2015-07-01 12:00', end_time: '2015-07-01 16:00')



