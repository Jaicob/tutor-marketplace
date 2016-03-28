class ApptRescheduler

  def initialize(appt_id, params)
    @appt = Appointment.find(appt_id)
    @original_time = @appt.start_time
    @unformatted_appt_info = params[:appt_info]
    if params[:reschedule_appt]
      @slot_id = params[:reschedule_appt][:slot_id]
      @start_time = params[:reschedule_appt][:start_time]
    end
  end

  def format_new_time
    if @unformatted_appt_info != nil
      data = @unformatted_appt_info.split("----")
      return {
        success: true,
        new_start_time: data.first,
        new_slot_id: data.second,
      }
    else
      return {
        success: false,
      }
    end
  end

  def reschedule_appt
    if @appt.no_reschedule_allowed?
      response = {success: false, error: 'Due to our 24-hour policy, this appointment can no longer be rescheduled', error_type: '24-hour-policy'}
      return response
    end
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
    return response
  end

end