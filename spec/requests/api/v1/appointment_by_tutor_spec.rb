require 'rails_helper'

describe "AppointmentsByTutor endpoints" do
  let(:tutor) { create(:tutor) }
  let(:second_tutor) { create(:second_complete_tutor ) }
  let(:course) { create(:course) }
  let(:slot) { create(:slot, tutor: tutor) }

  # creates two appointments for tutor
  before :each do
    @appt_a = create(:appointment, slot_id: slot.id)
    @appt_b = create(:appointment, slot_id: slot.id, start_time: '2015-09-01 13:00')
  end 

  # logs in tutor to gain access to protected API endpoints
  def request_spec_login(user)
    login_params = {user: {email: user.email, password: user.password}}
    post "/users/sign_in", login_params
  end

  it 'denies access to get appointment(s) for a non-logged in user' do 
    get "/api/v1/tutors/#{tutor.id}/appointments"
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    
    get "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}"
    expect(response).to_not be_success
    expect(response.status).to eq(401)
  end

  it 'does return appointments for a tutor' do 
  end

  it 'does not return appointments for a tutor other than the owner' do 
    request_spec_login(second_tutor.user)
    get "/api/v1/tutors/#{tutor.id}/appointments"
    expect(response).to_not be_success
    expect(response.status).to eq(401)
  end

  it 'returns list of all appointments for a tutor' do
    request_spec_login(tutor.user)
    get "/api/v1/tutors/#{tutor.id}/appointments"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it 'returns a specific appointment for a tutor' do 
    request_spec_login(tutor.user)
    get "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}"
    expect(response).to be_success
    expect(json['id']).to eq(@appt_a.id)
  end

  it 'creates an appointment for a tutor' do
    request_spec_login(tutor.user)
    params = {
      tutor_id: tutor.id,
      course_id: course.id,
      slot_id: slot.id,
      start_time: "2015-09-01 10:00:00"
    }
    expect{
      post "/api/v1/tutors/#{tutor.id}/appointments/", params
    }.to change(Appointment, :count).by(1)
    expect(response).to be_success
  end

  it 'updates an appointment for a tutor' do 
    request_spec_login(tutor.user)
    get "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}"
    expect(@appt_a.status).to eq('Scheduled')
    params = {status: 'Cancelled'}
    put "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}", params
    expect(@appt_a.reload.status).to eq('Cancelled')
    expect(response).to be_success
  end

  it 'destroys an appointment for a tutor' do 
    request_spec_login(tutor.user)
    expect{
      delete "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}"
    }.to change(Appointment, :count).by(-1)
  end

end