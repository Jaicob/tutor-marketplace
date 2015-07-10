describe "Schedule Block API" do
  let(:tutor) { create(:tutor) }
  let(:schedule_block) { create(:schedule_block) }

  it "Returns all schedule_blocks for a tutor" do 
    tutor.schedule_blocks.create(attributes_for(:schedule_block, tutor_id: tutor.id))
    get "/api/v1/tutors/#{tutor.id}/schedule_blocks"
    expect(response).to be_success
    expect(json.length).to eq(1)
  end

  it "Returns a specific schedule_block for a tutor" do 
    schedule_block = tutor.schedule_blocks.create(attributes_for(:schedule_block, tutor_id: tutor.id))
    get "/api/v1/tutors/#{tutor.id}/schedule_blocks/#{schedule_block.id}"
    expect(response).to be_success
    expect(json['id']).to eq(schedule_block.id)
    expect(json['tutor_id']).to eq(schedule_block.tutor.id)
  end

  it "Creates a schedule_block for a tutor" do 
    skip 'not sure how to test yet'
  end

  # Update with PUT
  it "Updates a schedule_block for a tutor" do 
    skip 'not sure how to test yet'
  end

  # Update with PATCH
  it "Updates a schedule_block for a tutor" do 
    skip 'not sure how to test yet'
  end

  it "Deletes a schedule_block for a tutor" do
    skip 'not sure how to test yet'
  end
end