class AppointmentMailer < ApplicationMailer
  default from: 'info@axontutors.com'
  default template_path: "mailers/#{self.name.underscore}"

  # ==============================
  #      Confirmation Emails
  # ==============================

  def appointment_confirmation_for_tutor(appointment_id)
    appointment = Appointment.find(appointment_id)
    @tutor = appointment.tutor
    @student = appointment.student
    @appt = appointment
    @url = 'link to schedule or appointment confirmation page'
    mail(to: @tutor.email, subject: "You have a new appointment!")
  end

  def appointment_confirmation_for_student(appointment_id)
    appointment = Appointment.find(appointment_id)
    @tutor = appointment.tutor
    @student = appointment.student
    @appt = appointment
    @url = 'link to schedule or appointment confirmation page'
    mail(to: @student.email, subject: "Your Axon tutoring appointment confirmation")
  end

  def test_email_x(appointment_id)
    @appointment = Appointment.find(appointment_id)
    mail(to: 'jtjobe@gmail.com', subject: 'sidekiq worked mofo!')
  end

  # ==============================
  #   Update Appointment Emails
  # ==============================

  def appointment_update_for_tutor(appointment_id)
    appointment = Appointment.find(appointment_id)
    @tutor = appointment.tutor
    @student = appointment.student
    @appt = appointment
    @url = 'link to schedule or appointment confirmation page'
    mail(to: @tutor.email, subject: "Your Axon tutoring appointment has changed")
  end

  def appointment_update_for_student(appointment_id)
    appointment = Appointment.find(appointment_id)
    @tutor = appointment.tutor
    @student = appointment.student
    @appt = appointment
    @url = 'link to schedule or appointment confirmation page'
    mail(to: @student.email, subject: "Your Axon tutoring appointment has changed")
  end

  # ==============================
  #  Appointment Reminder Emails
  # ==============================

  def appointment_reminder_for_tutor(appointment_id)
    appointment = Appointment.find(appointment_id)
    @tutor = appointment.tutor
    @student = appointment.student
    @appt = appointment
    @url = 'link to schedule or appointment confirmation page'
    mail(to: @tutor.email, subject: "Your upcoming Axon appointment")
  end

  def appointment_reminder_for_student(appointment_id)
    appointment = Appointment.find(appointment_id)
    @tutor = appointment.tutor
    @student = appointment.student
    @appt = appointment
    @url = 'link to schedule or appointment confirmation page'
    mail(to: @student.email, subject: "Your upcoming Axon appointment")
  end

end