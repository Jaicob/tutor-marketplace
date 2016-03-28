class CreateAppointments
  include Interactor

  # required_params
    # :tutor_id
    # :student_id
    # :stripe_token
    # :appts_info [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]
    # :promotion_id (optional)

  def call
    begin 
      context.appointments = []

      context.appts_info.each do |appt_info|
        new_appt = Appointment.create(
          student_id: context.student_id,
          slot_id: appt_info[:slot_id],
          course_id: appt_info[:course_id],
          start_time: appt_info[:start_time],
          location: context.location
        )
        if new_appt.save
          context.appointments << new_appt
        else
          new_appt.destroy
          raise "Appointment was not created: #{new_appt.errors.full_messages.first}"
        end
      end  
    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end

  def rollback
    context.appointments.each do |appt|
      appt.destroy
    end
  end

end










##
# => For easy testing...
#
# CreateAppointments.call(
#   tutor_id: 1,
#   student_id: 1,
#   stripe_token: nil,
#   appts_info: [
#     {slot_id: 1, course_id: 1, start_time: "2015-12-08 12:00:00" },
#     {slot_id: 2, course_id: 1, start_time: "2015-12-15 12:00:00" },
#   ],
#   promotion_id: nil
# )
#
#<Student id: 1, user_id: 105, school_id: 1, phone_number: nil, created_at: "2015-12-08 19:10:21", updated_at: "2015-12-08 19:10:21", customer_id: nil, last_4_digits: nil, card_brand: nil>
#<Tutor id: 1, user_id: 1, school_id: 1, active_status: 1, application_status: 0, rating: 5, degree: 5, major: "Micro-Biology", additional_degrees: "B.S. Chemistry, B.S. Micro-Biology", extra_info_1: "This is a short extra info example for showing dif...", extra_info_2: "This is a long extra info example for showing the ...", extra_info_3: "This is a long extra info example for showing the ...", graduation_year: "2016", phone_number: "5409124737", profile_pic: nil, transcript: nil, appt_notes: nil, onboarding_status: 0, created_at: "2015-12-08 19:09:45", updated_at: "2015-12-08 19:10:09", last_4_acct: nil, line1: nil, line2: nil, city: nil, state: nil, postal_code: nil, ssn_last_4: nil, acct_id: nil>
#<Slot id: 1, tutor_id: 1, status: 0, start_time: "2015-12-08 12:00:00", duration: 7200, reservation_min: nil, reservation_max: nil, created_at: "2015-12-08 19:09:56", updated_at: "2015-12-08 19:09:56">
#<Course id: 1, school_id: 1, subject_id: 1, call_number: "101", friendly_name: "Intro to Biology (U1)", created_at: "2015-12-08 19:09:33", updated_at: "2015-12-08 19:09:33">
#<Slot id: 2, tutor_id: 1, status: 0, start_time: "2015-12-15 12:00:00", duration: 7200, reservation_min: nil, reservation_max: nil, created_at: "2015-12-08 19:09:56", updated_at: "2015-12-08 19:09:56">