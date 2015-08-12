class ApptReminderWorker
  include Sidekiq::Worker 

  def perform(appointment_id)
    @appt = Appointment.find(appointment_id)
    @date = Time.at(@appt.appt_reminder_email_date).to_date
    if @date == Date.today
      AppointmentMailer.appointment_reminder_for_tutor(appointment_id)
      AppointmentMailer.appointment_reminder_for_student(appointment_id)
    end
  end
end