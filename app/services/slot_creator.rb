class SlotCreator

  def initialize(params)
    @tutor = params[:tutor_id] 
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @start_time = params[:start_time].to_date
    @end_time = params[:end_time].to_date
  end 

  def create_slots
    date = @start_date
    while date < @end_date
      Slot.create(start_time: @start_time, end_time: @end_time)
      date = date + 7
    end 
  end

end

# sc = SlotCreator.new(tutor_id: 1, start_date: '2015-07-01', end_date: '2015-12-20', start_time: '2015-07-01 12:00', end_time: '2015-07-01 16:00')
