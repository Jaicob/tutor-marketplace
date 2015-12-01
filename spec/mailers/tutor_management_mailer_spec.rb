require "rails_helper"

# These are request specs, rather than standard mailer specs. Mailer specs simply test the content of emails which we can easily do by inspecting the templates. Request specs actually test that the emails are triggered and sent correctly. These tests were originally spread throughout various files in '/requests/api/v1/..' and I decided to group them here in order to make it easier find and test all our emails at once.

describe 'Tutor Management mailers', type: 'request' do 
  let(:tutor) { create(:tutor) }
  let(:student) { create(:student) }
  let(:course) { create(:course) }
  let(:slot) { create(:slot, tutor: tutor, start_time: '2020-01-01 10:00') }
  let(:appt) { create(:appointment) }
  let(:almost_complete_tutor) { create(:tutor_with_complete_application, degree: nil) }
  let(:school) { create(:school) }
  let(:admin) { create(:user, :admin) }

  # logs in tutor/student to gain access to protected API endpoints
  def request_spec_login(user)
    login_params = {user: {email: user.email, password: user.password}}
    post "/users/sign_in", login_params
  end

  it 'sends welcome_email upon tutor sign_up' do
    expect(User.count).to eq 0
    expect(Tutor.count).to eq 0
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
    params = {
      user: {
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'jane@example.com',
        password: 'password',
        tutor: {
          extra_info: "I'm smart",
          phone_number: '123-234-3456'
        }
      },
      course: {
        school_id: school.id,
        subject_id: course.subject.id
      },
      tutor_course: {
        course_id: course.id,
        rate: 20
      }
    }
    post '/users', params
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 1
    expect(User.count).to eq 1
    expect(Tutor.count).to eq 1
  end


 # self.complete_profile? && self.application_status == 'Incomplete'
  it 'sends application_completed_email to tutors upon application completion' do
    @tutor = almost_complete_tutor
    request_spec_login(@tutor.user)
    expect(@tutor.complete_profile?).to eq false
    expect(@tutor.application_status).to eq 'Incomplete'
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
    params = {
        tutor: {
          degree: 'B.A.'
      }
    }
    put "/tutors/#{@tutor.id}", params
    @tutor.reload.update_application_status
    expect(@tutor.application_status).to eq 'Complete'
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 1
  end

  it 'sends activation_email when an admin accepts an application' do
    request_spec_login(admin)
    expect(tutor.active_status).to eq 'Inactive'
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
    params = {
      tutor: {
        active_status: 'Active'
      }
    }
    patch "/admin/tutors/#{tutor.id}", params
    expect(tutor.reload.active_status).to eq 'Active'
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 1
  end

  it 'sends deactivation_email when an admin deactives a tutor' do
    request_spec_login(admin)
    request_spec_login(admin)
    tutor = create(:tutor, active_status: 'Active')
    expect(tutor.active_status).to eq 'Active'
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
    params = {
      tutor: {
        active_status: 'Inactive'
      }
    }
    patch "/admin/tutors/#{tutor.id}", params
    expect(tutor.reload.active_status).to eq 'Inactive'
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 1
  end

end