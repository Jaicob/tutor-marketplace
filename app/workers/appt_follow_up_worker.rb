class ApptReminderWorker
  include Sidekiq::Worker 

  # This worker handles the appointment follow-up emails. It only 
  # sends a follow-up email if the appt_follow_up_email_time on an appointment
  # matches the current date, which effectively disables any out-of-date 
  # reminders from being sent if the appointment date was changed.

  def perform(appointment_id)
    @appt = Appointment.find(appointment_id)
    @date = @appt.appt_follow_up_email_time.to_date
    if @date == Date.today && @appt.status == 'Scheduled'
      AppointmentMailer.appointment_follow_up_for_student(appointment_id)
    end
  end
end