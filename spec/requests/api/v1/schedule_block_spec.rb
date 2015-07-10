describe "Schedule Block API" do
  let(:tutor) { create(:tutor) }
  let(:schedule_block) { create(:schedule_block) }

  it "Returns a list of all schedule_blocks for a tutor" do 
    tutor.schedule_blocks.create(attributes_for(:schedule_block, tutor_id: tutor.id))
    get "/api/v1/tutors/#{tutor.id}/schedule_blocks"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  # it "Returns a specific school" do 
  #   get "/api/v1/schools/#{school.id}"
  #   expect(response).to be_success
  #   expect(json['name']).to eq(school.name)
  # end

  # it "Returns all of a school's courses" do 
  #   get "/api/v1/schools/#{school_with_courses.id}/courses"
  #   expect(response).to be_success
  #   expect(json.length).to eq(2)
  # end

  # it "Returns all of a school's subjects" do 
  #   get "/api/v1/schools/#{school_with_courses.id}/subjects"
  #   expect(response).to be_success
  #   expect(json.length).to eq(2) 
  # end

  # it "Returns a school's courses for a specific subject" do
  #   get "/api/v1/schools/#{school_with_bio_courses.id}/subjects/0/courses"
  #   expect(response).to be_success
  #   expect(json.length).to eq(2)
  # end

end