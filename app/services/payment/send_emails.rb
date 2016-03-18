class SendEmails
  include Interactor

  def call
    begin 
      context.appointments.each do |appt|
        AppointmentMailer.delay.appointment_confirmation_for_tutor(appt.id)
        AppointmentMailer.delay.appointment_confirmation_for_student(appt.id)
        # initialize Sidekiq workers to send appt_reminder_email IF the appt is more than 24 hours away
        if appt.appt_reminder_email_time != nil
          ApptReminderWorker.perform_at(appt.appt_reminder_email_time, appt.id)
          ApptReminderWorker.perform_at(appt.appt_reminder_email_time, appt.id)
        end
        # initliaze Sidekiq workers to send appt_follow_up email
        ApptFollowUpWorker.perform_at(appt.appt_follow_up_email_time, appt.id)
      end
    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end

end