describe "Slot endpoints" do 
  let(:slot) { create(:slot) }
  let(:tutor) { create(:tutor) }

  it "Returns all of a tutor's slot" do
    slot
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
    expect {post "/api/v1/tutors/#{tutor.id}/slots", attributes_for(:slot_creator_one_slot)
    }.to change(Slot, :count).by(1)
  end

end
