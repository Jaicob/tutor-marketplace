describe "School endpoints" do
  let(:school) { create(:school) }
  let(:school_with_courses) { create(:school_with_courses) }
  let(:school_with_bio_courses) { create(:school_with_bio_courses) }

  it "Returns a list of all schools" do 
    create_list(:school, 10)
    get "/api/v1/schools"
    expect(response).to be_success
    expect(json.length).to eq(10)
  end

  it "Returns a specific school" do 
    get "/api/v1/schools/#{school.id}"
    expect(response).to be_success
    expect(json['name']).to eq(school.name)
  end

  it "Returns all of a school's courses" do 
    get "/api/v1/schools/#{school_with_courses.id}/courses"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns all of a school's subjects" do 
    get "/api/v1/schools/#{school_with_courses.id}/subjects"
    expect(response).to be_success
    expect(json.length).to eq(2) 
  end

  it "Returns a school's courses for a specific subject" do
    get "/api/v1/schools/#{school_with_bio_courses.id}/subjects/0/courses"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

end
