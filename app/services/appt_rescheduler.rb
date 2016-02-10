class ApptRescheduler

  def initialize(appt_id, params)
    @appt = Appointment.find(appt_id)
    @original_time = @appt.start_time
    @raw_data = params[:appt_selection]
  end

  def format_new_time
    if @raw_data != nil && @raw_data.to_hash.values.count == 1
      x = @raw_data.to_hash.values[0].split("----")
      @start_time = x.first
      @slot_id = x.second
      @valid_new_time = true
    else
      @valid_new_time = false
    end
  end

  def reschedule_appt
    if @appt.no_reschedule_allowed?
      response = {success: false, error: 'Due to our 24-hour policy, this appointment can no longer be rescheduled', error_type: '24-hour-policy'}
      return response
    end
    format_new_time
    if @valid_new_time == true
      if @appt.update(
          start_time: @start_time, 
          slot_id: @slot_id
        )
        AppointmentMailer.delay.appointment_reschedule_for_tutor(@appt.id, @original_time)
        AppointmentMailer.delay.appointment_reschedule_for_student(@appt.id, @original_time)
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