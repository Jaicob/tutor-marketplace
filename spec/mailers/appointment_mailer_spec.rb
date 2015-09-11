require "rails_helper"

# These are request specs, rather than standard mailer specs. Mailer specs simply test the content of emails which we can easily do by inspecting the templates. Request specs actually test that the emails are triggered and sent correctly. These tests were originally spread throughout various files in '/requests/api/v1/..' and I decided to group them here in order to make it easier find and test all our emails at once.

describe 'Appointment mailers', type: 'request' do 
  let(:tutor) { create(:tutor) }

  # logs in tutor/student to gain access to protected API endpoints
  def request_spec_login(user)
    login_params = {user: {email: user.email, password: user.password}}
    post "/users/sign_in", login_params
  end

  before :each do
    request_spec_login(tutor.user)
    slot = create(:slot, tutor_id: tutor.id, start_time: '2016-01-01 12:00')
    @appt_a = create(:appointment, slot_id: slot.id, start_time: '2016-01-01 12:00')
    @appt_b = create(:appointment, slot_id: slot.id, start_time: '2016-01-01 13:00')
  end

  it 'sends appointment confirmation to a tutor for a new booking' do 
    
  end

end


# appointment_confirmation_for_tutor(appointment_id)
# appointment_confirmation_for_student(appointment_id)

# appointment_reminder_for_tutor(appointment_id)
# appointment_reminder_for_student(appointment_id)

# appointment_update_for_tutor(appointment_id)
# appointment_update_for_student(appointment_id)

# appointment_cancellation_for_tutor(appointment_id)
# appointment_cancellation_for_student(appointment_id)
