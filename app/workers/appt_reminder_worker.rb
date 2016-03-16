class ApptReminderWorker
  include Sidekiq::Worker 

  # This worker handles the appointment reminder emails. It only 
  # sends a reminder email if the appt_reminder_email_time on an appointment
  # matches the current date, which effectively disables any out-of-date 
  # reminders from being sent if the appointment date was changed.

  def perform(appointment_id)
    @appt = Appointment.find(appointment_id)
    @date = @appt.appt_reminder_email_time.to_date
    if @date == Date.today && @appt.status == 'Scheduled'
      AppointmentMailer.appointment_reminder_for_tutor(appointment_id)
      AppointmentMailer.appointment_reminder_for_student(appointment_id)
    end
  end
end