class ApptRescheduler

  def initialize(appt_id, params)
    @appt = Appointment.find(appt_id)
    @raw_data = params[:appt_selection]
  end

  def format_new_time
    if @raw_data != nil && @raw_data.to_unsafe_hash.values.count == 1
      x = @raw_data.to_unsafe_hash.values[0].split("----")
      @start_time = x.first
      @slot_id = x.second
      @valid_new_time = true
    else
      @valid_new_time = false
    end
  end

  def reschedule_appt
    format_new_time
    if @valid_new_time == true
      if @appt.update(
          start_time: @start_time, 
          slot_id: @slot_id
        )
        response = {success: true}
      else
        response = {success: false, error: @appt.errors.full_messages.first}
      end
    else
      response = {success: false, error: 'Please select one new meeting time'}
    end
    return response
  end

end