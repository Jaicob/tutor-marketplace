require 'rails_helper'

describe "AppointmentsByStudent endpoints" do
  let(:student) { create(:student) }
  let(:slot) { create(:slot) }

  before :each do
    @appt_a = create(:appointment, student_id: student.id)
    @appt_b = create(:appointment, student_id: student.id)
  end 

  it 'returns list of all appointments for a student' do 
    get "/api/v1/students/#{student.id}/appointments"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it 'returns a specific appointment for a student' do 
    get "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}"
    expect(response).to be_success
    expect(json['id']).to eq(@appt_a.id)
  end

  it 'creates an appointment for a student' do
    expect(emails.count).to eq 0
    params = {
      student_id: student.id,
      slot_id: slot.id,
      start_time: "2015-09-01 10:00:00"
    }
    expect{
      post "/api/v1/students/#{student.id}/appointments/", params
    }.to change(Appointment, :count).by(1)
    expect(response).to be_success
    expect(emails.count).to eq 2
    expect(email_addresses).to include([slot.tutor.email], [student.email])
  end

  it 'updates an appointment for a student' do 
    expect(emails.count).to eq 0
    expect(@appt_a.status).to eq(nil)
    params = {status: 99}
    put "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}", params
    expect(@appt_a.reload.status).to eq(99)
    expect(response).to be_success
    expect(emails.count).to eq 2
    expect(email_addresses).to include([@appt_a.tutor.email],[student.email])
  end

  it 'destroys an appointment for a student' do 
    expect{
      delete "/api/v1/students/#{student.id}/appointments/#{@appt_a.id}"
    }.to change(Appointment, :count).by(-1)
  end

end