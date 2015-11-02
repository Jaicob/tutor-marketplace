class SendEmails
  include Interactor

  def call
    AppointmentMailer.delay.appointment_confirmation_for_tutor(@appt.id)
    AppointmentMailer.delay.appointment_confirmation_for_student(@appt.id)
    if @appt.appt_reminder_email_date != nil
      ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
      ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
    end
  end
  
end