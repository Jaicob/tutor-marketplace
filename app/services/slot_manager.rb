class SlotManager

  def initialize(params)
    @tutor = params[:tutor_id] 
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def list_slots(params)
    Slots.find_by(start_time: params[:start_time].t, end_time: params[:end_time])
  end

  def update_slots(params)

  end

  def destroy_slots
  end

end