require "rails_helper"

# These are request specs, rather than standard mailer specs. Mailer specs simply test the content of emails which we can easily do by inspecting the templates. Request specs actually test that the emails are triggered and sent correctly. These tests were originally spread throughout various files in '/requests/api/v1/..' and I decided to group them here in order to make it easier find and test all our emails at once.

describe 'Appointment mailers', type: 'request' do 
  let(:tutor) { create(:tutor) }
  let(:student) { create(:student) }
  let(:course) { create(:course) }
  let(:slot) { create(:slot, tutor: tutor, start_time: '2020-01-01 10:00') }

  # logs in tutor/student to gain access to protected API endpoints
  def request_spec_login(user)
    login_params = {user: {email: user.email, password: user.password}}
    post "/users/sign_in", login_params
  end

  it 'sends appointment confirmations (to tutor and student) for a new booking' do 
    request_spec_login(student.user)
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
    params = {
      student_id: student.id,
      course_id: course.id,
      slot_id: slot.id,
      start_time: "2020-01-01 10:00:00"
    }
    expect{
      post "/api/v1/students/#{student.id}/appointments/", params
    }.to change(Appointment, :count).by(1)
    expect(response).to be_success
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 2
  end

  it 'sets up an ApptReminderWorker for appts booked more than 24 hours out' do 
    request_spec_login(student.user)
    params = {
      student_id: student.id,
      course_id: course.id,
      slot_id: slot.id,
      start_time: "2020-01-01 10:00:00"
    }
    expect{
      post "/api/v1/students/#{student.id}/appointments/", params
    }.to change(ApptReminderWorker.jobs, :size).by(2)
  end

  it 'does not set up an ApptReminderWorker for appts booked less than 24 out' do
    slot_12_hours_from_now = create(:)
    request_spec_login(student.user)
    params = {
      student_id: student.id,
      course_id: course.id,
      slot_id: slot.id,
      start_time: "2020-01-01 10:00:00"
    }
    expect{
      post "/api/v1/students/#{student.id}/appointments/", params
    }.to change(ApptReminderWorker.jobs, :size).by(2)
  end

end




# appointment_reminder_for_tutor(appointment_id)
# appointment_reminder_for_student(appointment_id)

# appointment_update_for_tutor(appointment_id)
# appointment_update_for_student(appointment_id)

# appointment_cancellation_for_tutor(appointment_id)
# appointment_cancellation_for_student(appointment_id)


  # {
  #   "id": 507,
  #   "tutor_id": 1,
  #   "status": "Open",
  #   "start_time": "2015-09-06T11:00:00.000Z",
  #   "duration": 7200,
  #   "reservation_min": null,
  #   "reservation_max": null,
  #   "created_at": "2015-09-10T16:56:12.543Z",
  #   "updated_at": "2015-09-10T16:56:31.076Z"
  # },
