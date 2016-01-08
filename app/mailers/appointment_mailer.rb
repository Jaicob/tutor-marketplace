class AppointmentMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  before_action :set_tutor_and_student

  # ==============================
  #   Appointment Confirmation Emails
  # ==============================

  def appointment_confirmation_for_tutor(appointment_id)
    mail(to: @tutor.email, subject: "You have a new appointment with Axon")
  end

  def appointment_confirmation_for_student(appointment_id)
    mail(to: @student.email, subject: "Your Axon tutoring appointment confirmation")
  end

  # ==============================
  #  Appointment Reminder Emails
  # ==============================

  def appointment_reminder_for_tutor(appointment_id) 
    mail(to: @tutor.email, subject: "Your upcoming Axon tutoring appointment")
  end

  def appointment_reminder_for_student(appointment_id)
    mail(to: @student.email, subject: "Your upcoming Axon tutoring appointment")
  end

  # ================================
  #   Appointment Rescheduled Emails
  # ================================

  def appointment_reschedule_for_tutor(appointment_id)
    mail(to: @tutor.email, subject: "Your Axon tutoring appointment has changed")
  end

  def appointment_reschedule_for_student(appointment_id)
    mail(to: @student.email, subject: "Your Axon tutoring appointment has changed")
  end

  # ================================
  #  Appointment Cancellation Emails
  # ================================

  def appointment_cancellation_for_tutor(appointment_id)
    mail(to: @tutor.email, subject: "One of your Axon appointments has been cancelled")
  end

  def appointment_cancellation_for_student(appointment_id)  
    mail(to: @student.email, subject: "Your appointment has been cancelled")
  end

  private

    def set_tutor_and_student
      @appt = Appointment.find(appointment_id)
      @tutor = @appt.tutor
      @student = @appt.student 
    end
    
end