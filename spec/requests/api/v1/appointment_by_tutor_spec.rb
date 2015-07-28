require 'rails_helper'

describe "AppointmentByTutor endpoints" do 
  let(:tutor) { create(:tutor) }

  before :each do
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
    expect(@appt_a.status).to eq(nil)
    params = {status: 99}
    put "/api/v1/tutors/#{tutor.id}/appointments/#{@appt_a.id}", params
    expect(@appt_a.reload.status).to eq(99)
  end

end  