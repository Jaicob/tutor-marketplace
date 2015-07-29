class AppointmentsMailer < ApplicationMailer
  default from: 'info@axontutors.com'

  def appointment_confirmation_for_tutor(tutor)
    @tutor = tutor
    @url = 'link to schedule or appointment confirmation page'
  end

  def appointment_confirmation_for_student(student)
    @student = student
    @url = 'link to schedule or appointment confirmation page'
  end

end
