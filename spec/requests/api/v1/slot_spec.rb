describe "Slot endpoints" do 
  let(:slot) { create(:slot) }

  it "Returns all slots" do 
    create_list(:slot, 4)
    get "/api/v1/slots"
    expect(response).to be_success
    expect(json.length).to eq(4)
  end

  it "Returns a slot" do 
    slot
    get "/api/v1/slots/#{slot.id}"
    expect(response).to be_success
    expect(json['id']).to eq(slot.id)
  end

  it "Creates a single slot" do 
    expect { 
      post "/api/v1/slots", slot: attributes_for(:slot)
    }.to change(Slot, :count).by(1)     
  end

end
