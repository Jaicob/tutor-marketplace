class SendEmails
  include Interactor

  def call
    begin     
      context.appointments.each do |appt|
        AppointmentMailer.delay.appointment_confirmation_for_tutor(appt.id)
        AppointmentMailer.delay.appointment_confirmation_for_student(appt.id)
        if appt.appt_reminder_email_date != nil
          ApptReminderWorker.perform_at(appt.appt_reminder_email_date, appt.id)
          ApptReminderWorker.perform_at(appt.appt_reminder_email_date, appt.id)
        end
      end
    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end

end