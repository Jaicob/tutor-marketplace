require 'rails_helper'

describe "Slot endpoints" do 
  
  let(:slot)  { create(:slot) }
  let(:tutor) { create(:tutor) }

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
    request_spec_login(tutor.user) 
    params = {
      tutor_id: tutor.id, 
      start_time: '2015-08-01 12:00:00', 
      duration: 1200, 
      weeks_to_repeat: 1
    }
    expect { post "/api/v1/tutors/#{tutor.id}/slots", params
    }.to change(Slot, :count).by(1)
    expect(response).to be_success
  end

  it "Creates multiple repeating slots with SlotCreator" do 
    request_spec_login(tutor.user) 
    params = {
      tutor_id: tutor.id, 
      start_time: '2015-08-01 12:00:00', 
      duration: 1200, 
      weeks_to_repeat: 5
    }
    expect { post "/api/v1/tutors/#{tutor.id}/slots", params
    }.to change(Slot, :count).by(5)
    expect(response).to be_success
  end

  it "Update all slots for tutor in a range" do
    # long, but necessary setup for test (need to create slots with SlotCreator first)
    request_spec_login(tutor.user) 
    params = {
      tutor_id: tutor.id, 
      start_time: '2015-08-01 12:00:00', 
      duration: 1200, 
      weeks_to_repeat: 5
    }
    expect { post "/api/v1/tutors/#{tutor.id}/slots", params
    }.to change(Slot, :count).by(5)
    expect(response).to be_success
    # end of SlotCreator setup, now to test SlotManager for updating functionality

    # confirm slot details before updating
      # first slot details
    expect(tutor.slots.first.start_time).to eq ('2015-08-01 12:00:00')
    expect(tutor.slots.first.duration).to eq (1200)
      # second slot details
    expect(tutor.slots.last.start_time).to eq ('2015-08-29 12:00:00')
    expect(tutor.slots.last.duration).to eq (1200)

    puts "FIRST SLOT ID = #{tutor.slots.first.id}"

    # post request to update slots
    params = {
      tutor_id: tutor.id, 
      original_start_time: '2015-08-01 12:00:00', 
      original_duration: 1200, 
      new_start_time: '2015-08-02 9:00:00', 
      new_duration: 2400
    }
    post "/api/v1/tutors/#{tutor.id}/slots/update", params
    expect(response.status).to eq(200)

    # check for updated values
      # first slot details
    expect(tutor.slots.first.reload.start_time).to eq ('2015-08-02 9:00:00')
    expect(tutor.slots.first.duration).to eq (2400)
    #   # second slot details
    expect(tutor.slots.last.start_time).to eq ('2015-08-30 9:00:00')
    expect(tutor.slots.last.duration).to eq (2400)


  end

end