require "rails_helper"

# These are request specs, rather than standard mailer specs. Mailer specs simply test the content of emails which we can easily do by inspecting the templates. Request specs actually test that the emails are triggered and sent correctly. These tests were originally spread throughout various files in '/requests/api/v1/..' and I decided to group them here in order to make it easier find and test all our emails at once.

describe 'Appointment mailers', type: 'request' do 
  let(:tutor) { create(:tutor) }
  let(:student) { create(:student) }
  let(:course) { create(:course) }
  let(:slot) { create(:slot, tutor: tutor, start_time: '2020-01-01 10:00') }
  let(:appt) { create(:appointment) }

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
    start_time = DateTime.now
    no_reminder_slot = create(:slot, tutor: tutor, start_time: start_time)
    request_spec_login(student.user)
    params = {
      student_id: student.id,
      course_id: course.id,
      slot_id: slot.id,
      start_time: start_time
    }
    expect{
      post "/api/v1/students/#{student.id}/appointments/", params
    }.to change(ApptReminderWorker.jobs, :size).by(0)
  end

  it 'sends appointment_update (to tutor and student) when changes are made' do
    student = appt.student
    request_spec_login(student.user)
    params = {
      start_time: (appt.start_time.to_datetime + 2.hours).to_s
    }
    expect{
      put "/api/v1/students/#{student.id}/appointments/#{appt.id}/reschedule", params
    }.to change(Appointment, :count).by(0)
    expect(response).to be_success
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 2
  end

  it 'sends appointment_cancellation (to tutor and student) when appt is cancelled' do 
    student = appt.student
    request_spec_login(student.user)
    params = {
      status: 'Cancelled'
    }
    expect{
      put "/api/v1/students/#{student.id}/appointments/#{appt.id}/reschedule", params
    }.to change(Appointment, :count).by(0)
    expect(response).to be_success
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 2
  end

end