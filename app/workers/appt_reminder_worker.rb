class ApptReminderWorker
  include Sidekiq::Worker 

  # This workers handles the appointment reminder emails. It only 
  # sends a reminder email if the appt_reminder_email_date on an appointment
  # matches the current date, which effectively disables any out-of-date 
  # reminders from being sent if the appointment date was changed.

  def perform(appointment_id)
    @appt = Appointment.find(appointment_id)
    @date = Time.at(@appt.appt_reminder_email_date).to_date
    if @date == Date.today
      AppointmentMailer.appointment_reminder_for_tutor(appointment_id)
      AppointmentMailer.appointment_reminder_for_student(appointment_id)
    end
  end
end