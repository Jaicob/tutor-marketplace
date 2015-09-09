require 'rails_helper'

describe "Slot endpoints" do 
  
  let(:slot)  { create(:slot) }

  # logs in tutor to gain access to protected API endpoints
  def request_spec_login(user)
    login_params = {user: {email: user.email, password: user.password}}
    post "/users/sign_in", login_params
  end

  it "Returns all of a signed-in tutor's slots" do
    create(:slot, tutor_id: slot.tutor.id) # to make sure the same tutor owns both
    get "/api/v1/tutors/#{slot.tutor.id}/slots"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns a specific slot for a signed-in tutor" do
    request_spec_login(slot.tutor.user) 
    get "/api/v1/tutors/#{slot.tutor.id}/slots/#{slot.id}"
    expect(response).to be_success
    expect(json['id']).to eq(slot.id)
  end

  it "Denies access to a request for a specific slot by anyone other than the tutor" do 
    get "/api/v1/tutors/#{slot.tutor.id}/slots/#{slot.id}"
    expect(response).to_not be_success
    expect(response.status).to eq(401)
  end

  it "Creates a single slot with SlotCreator" do
    request_spec_login(slot.tutor.user) 
    params = {
        tutor_id:         slot.tutor.id, 
        start_time:       '2015-08-01 17:00', 
        duration:         3600, 
        weeks_to_repeat:  1
      }
    expect { post "/api/v1/tutors/#{slot.tutor.id}/slots", params
    }.to change(Slot, :count).by(1)
    expect(response).to be_success
  end

  it "Creates multiple repeating slots with SlotCreator" do 
    request_spec_login(slot.tutor.user) 
    params = {
        tutor_id:         slot.tutor.id, 
        start_time:       '2015-08-01 17:00', 
        duration:         3600, 
        weeks_to_repeat:  5
      }
    expect { post "/api/v1/tutors/#{slot.tutor.id}/slots", params
    }.to change(Slot, :count).by(5)
    expect(response).to be_success
  end

  it "Update all slots for tutor in a range" do
    request_spec_login(slot.tutor.user) 
    slot_creator = SlotCreator.new(
      tutor_id: slot.tutor.id, 
      start_time: '2015-08-01 12:00:00', 
      duration: 3600, 
      weeks_to_repeat: 5
    ) 
    @slots = slot_creator.create_slots

    # Slot A before
    expect(@slots.first.start_time).to eq('2015-08-01 12:00:00')
    expect(@slots.first.duration).to eq(3600)

    # Slot B before
    expect(@slots.second.start_time).to eq('2015-08-08 12:00:00')
    expect(@slots.second.duration).to eq(3600)

    params = {
      tutor_id: slot.tutor.id,
      original_start_time: '2015-08-01 12:00:00', 
      original_duration: 3600, 
      new_start_time: '2015-08-02 9:00:00', 
      new_duration: 7200
      }
    post "/api/v1/tutors/#{slot.tutor.id}/slots/update", params
    expect(response).to be_success

    # Slot A after
    expect(@slots.first.reload.start_time).to eq('2015-08-02 9:00:00')
    expect(@slots.first.reload.duration).to eq(7200)

    # Slot B after
    expect(@slots.second.reload.start_time).to eq('2015-08-09 9:00:00')
    expect(@slots.second.reload.duration).to eq(7200)
  end

end