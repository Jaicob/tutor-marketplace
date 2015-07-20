describe "Slot endpoints" do 
  let(:slot)  { create(:slot) }
  
  let(:tutor) { create(:tutor) }
  let(:slots) { 4.times { Slot.new(tutor_id: tutor.id, start_time: "2015-08-14 12:00:00", end_time: "2015-08-14 13:00:00") } }

  it "Returns all of a tutor's slot" do
    create(:slot, tutor_id: slot.tutor.id) # to make sure the same tutor owns both
    get "/api/v1/tutors/#{slot.tutor.id}/slots"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns a specific slot of a tutor" do 
    slot
    get "/api/v1/tutors/#{slot.tutor.id}/slots/#{slot.id}"
    expect(response).to be_success
    expect(json['id']).to eq(slot.id)
  end

  it "Creates a single slot" do 
    tutor
    expect {post "/api/v1/tutors/#{tutor.id}/slots", attributes_for(:one_slot)
    }.to change(Slot, :count).by(1)
  end

  it "Update all slots for tutor in a range" do 
    slots
    post "/api/v1/tutors/#{slots[0].tutor.id}/slots/all", attributes_for(:many_slots)
    expect(response).to be_success
    expect(json.first["end_time"]).to eq("2015-08-14T12:00:00.000Z") 
    expect(json.last["end_time"]).to eq("2015-09-11T12:00:00.000Z")
  end


end