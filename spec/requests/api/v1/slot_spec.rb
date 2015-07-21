describe "Slot endpoints" do 
  
  let(:slot)  { create(:slot) }
  let(:tutor) { create(:tutor) }
  let(:slot_creator) {  SlotCreator.new(
      tutor_id: tutor.id, 
      start_time: '2015-08-01 12:00:00', 
      end_time: '2015-08-01 16:00:00', 
      weeks_to_repeat: 5) 
  }

  it "Returns all of a tutor's slot" do
    create(:slot, tutor_id: slot.tutor.id) # to make sure the same tutor owns both
    get "/api/v1/tutors/#{slot.tutor.id}/slots"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns a specific slot of a tutor" do 
    get "/api/v1/tutors/#{slot.tutor.id}/slots/#{slot.id}"
    expect(response).to be_success
    expect(json['id']).to eq(slot.id)
  end

  it "Creates a single slot with SlotCreator" do 
    params = {
        tutor_id:         tutor.id, 
        start_time:       '2015-08-01 17:00', 
        end_time:         '2015-08-01 20:00', 
        weeks_to_repeat:  1
      }
    expect { post "/api/v1/tutors/#{tutor.id}/slots", params
    }.to change(Slot, :count).by(1)
    expect(response).to be_success
  end

  it "Creates multiple repeating slots with SlotCreator" do 
    params = {
        tutor_id:         tutor.id, 
        start_time:       '2015-08-01 17:00', 
        end_time:         '2015-08-01 20:00', 
        weeks_to_repeat:  5
      }
    expect { post "/api/v1/tutors/#{tutor.id}/slots", params
    }.to change(Slot, :count).by(5)
    expect(response).to be_success
  end

  it "Update all slots for tutor in a range" do
    @slots = slot_creator.create_slots

    # Slot A before
    expect(@slots.first.start_time).to eq('2015-08-01 12:00:00')
    expect(@slots.first.end_time).to eq('2015-08-01 16:00:00')

    # Slot B before
    expect(@slots.second.start_time).to eq('2015-08-08 12:00:00')
    expect(@slots.second.end_time).to eq('2015-08-08 16:00:00')

    params = {
      original_start_time: '2015-08-01 12:00:00', 
      original_end_time: '2015-08-01 16:00:00', 
      new_start_time: '2015-08-02 9:00:00', 
      new_end_time: '2015-08-02 11:00:00'
      }
    put "/api/v1/tutors/#{tutor.id}/slots", params
    expect(response).to be_success

    # Slot A after
    expect(@slots.first.reload.start_time).to eq('2015-08-02 9:00:00')
    expect(@slots.first.reload.end_time).to eq('2015-08-02 11:00:00')

    # Slot B after
    expect(@slots.second.reload.start_time).to eq('2015-08-09 9:00:00')
    expect(@slots.second.reload.end_time).to eq('2015-08-09 11:00:00')
  end

end