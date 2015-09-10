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

  it "returns a list of all appointments for a tutor" do 
    get "/api/v1/tutors/#{tutor.id}/appointments"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "returns a specific appointment for a tutor" do 
    get "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}"
    expect(response).to be_success
    expect(json['id']).to eq(@appt_a.id)
    expect(json['slot_id']).to eq(@appt_a.slot_id)
  end

  it "updates an appointment for a tutor" do 
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
    expect(@appt_a.status).to eq('Scheduled')
    params = {status: 'Cancelled'}
    put "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}", params
    expect(@appt_a.reload.status).to eq('Cancelled')
    expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 2
  end
end