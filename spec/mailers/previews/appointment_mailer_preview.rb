class AppointmentMailerPreview < ActionMailer::Preview

  before_action :set_tutor_and_student

  def appointment_confirmation_for_tutor(appointment_id)
    AppointmentMailer.appointment_confirmation_for_tutor(Appointment.last.id)
  end

  def appointment_confirmation_for_student(appointment_id)
    AppointmentMailer.appointment_confirmation_for_student(Appointment.last.id)
  end

  # ==============================
  #  Appointment Reminder Emails
  # ==============================

  def appointment_reminder_for_tutor(appointment_id) 
    AppointmentMailer.appointment_reminder_for_tutor(Appointment.last.id)
  end

  def appointment_reminder_for_student(appointment_id)
    AppointmentMailer.appointment_reminder_for_student(Appointment.last.id)
  end

  # ================================
  #   Appointment Rescheduled Emails
  # ================================

  def appointment_reschedule_for_tutor(appointment_id)
    AppointmentMailer.appointment_reschedule_for_tutor(Appointment.last.id)
  end

  def appointment_reschedule_for_student(appointment_id)
    AppointmentMailer.appointment_reschedule_for_student(Appointment.last.id)
  end

  # ================================
  #  Appointment Cancellation Emails
  # ================================

  def appointment_cancellation_for_tutor(appointment_id)
    AppointmentMailer.appointment_cancellation_for_tutor(Appointment.last.id)
  end

  def appointment_cancellation_for_student(appointment_id)  
    AppointmentMailer.appointment_cancellation_for_student(Appointment.last.id)
  end

    private

    def set_tutor_and_student
      @appt = Appointment.last.id
      @tutor = @appt.tutor
      @student = @appt.student 
    end

end