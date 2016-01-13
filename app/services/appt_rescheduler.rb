class ApptRescheduler

  def initialize(appt_id, params)
    @appt = Appointment.find(appt_id)
    @raw_data = params[:appt_selection]
  end

  def format_info
    x = @raw_data.to_unsafe_hash.values[0].split("----")
    @start_time = x.first
    @slot_id = x.second
  end

  def reschedule_appt
    format_info
    if @appt.update(start_time: @start_time, slot_id: @slot_id)
      response = {
        success: true
      }
    else
      response = {
        success: false,
        error: @appt.errors.full_messages.first
      }
    end
    return response
  end

end