class ApptReminderWorker
  include Sidekiq::Worker 

  def perform(appointment_id)
    @appt = Appointment.find(appointment_id)
    if @appt.appt_reminder_email_date == Date.today
      AppointmentMailer.appointment_reminder_for_tutor(appointment_id)
      AppointmentMailer.appointment_reminder_for_student(appointment_id)
    end
  end
end