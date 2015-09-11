require 'rails_helper'

describe "AppointmentsByStudent endpoints" do
  let(:student) { create(:student) }
  let(:second_student) { create(:student, )}
  let(:course) { create(:course) }
  let(:slot) { create(:slot) }

  # creates two appointments for student
  before :each do
    @appt_a = create(:appointment, student_id: student.id)
    @appt_b = create(:appointment, student_id: student.id)
  end 

  # logs in student to gain access to protected API endpoints
  def request_spec_login(user)
    login_params = {user: {email: user.email, password: user.password}}
    post "/users/sign_in", login_params
  end

  it 'denies access to get appointment(s) for a non-logged in user' do 
    get "/api/v1/students/#{student.id}/appointments"
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    
    get "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}"
    expect(response).to_not be_success
    expect(response.status).to eq(401)
  end

  it 'does not return appointments for a student other than the owner' do 
    request_spec_login(second_student.user)
    get "/api/v1/students/#{student.id}/appointments"
    expect(response).to_not be_success
    expect(response.status).to eq(401)
  end

  it 'returns list of all appointments for a student' do
    request_spec_login(student.user)
    get "/api/v1/students/#{student.id}/appointments"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it 'returns a specific appointment for a student' do 
    request_spec_login(student.user)
    get "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}"
    expect(response).to be_success
    expect(json['id']).to eq(@appt_a.id)
  end

  it 'creates an appointment for a student' do
    request_spec_login(student.user)
    params = {
      student_id: student.id,
      course_id: course.id,
      slot_id: slot.id,
      start_time: "2015-09-01 10:00:00"
    }
    expect{
      post "/api/v1/students/#{student.id}/appointments/", params
    }.to change(Appointment, :count).by(1)
    expect(response).to be_success
  end

  it 'reschedules an appointment for a student' do 
    request_spec_login(student.user)
    get "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}"
    expect(@appt_a.start_time).to eq('2015-09-01 12:00')
    params = {start_time: '2015-09-01 13:00'}
    put "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}/reschedule", params
    expect(response).to be_success
    expect(@appt_a.reload.start_time).to eq('2015-09-01 13:00')
  end

  it 'cancels an appointment for a student' do 
    request_spec_login(student.user)
    get "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}"
    expect(@appt_a.status).to eq('Scheduled')
    params = {status: 'Cancelled'}
    put "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}/cancel", params
    expect(response).to be_success
    expect(@appt_a.reload.status).to eq('Cancelled')
  end

end