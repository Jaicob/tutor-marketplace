class CreateAppointments
  include Interactor

  # required_params
    # :tutor_id
    # :student_id
    # :stripe_token
    # :appts_info [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]
    # :promotion_id (optional)

  def call
    context.appts = []

    context.appts_info.each do |appt_info|
      new_appt = Appointment.create(
        student_id: context.student,
        slot_id: appt_info['slot_id'],
        course_id: appt_info['course_id'],
        start_time: appt_info['start_time']
      )
      context.appts << new_appt
    end

    puts "CONTEXT.APPTS = #{context.appts}"

  end

end