describe "Course API" do 
  let(:course) { create(:course) }

  it "Returns all courses" do
    create_list(:course, 10)
    get "/api/v1/courses"
    expect(response).to be_success
    expect(json.length).to eq(10)
  end

  it "Returns a specific course" do 
    get "/api/v1/courses/#{course.id}"
    expect(response).to be_success
    expect(json['id']).to eq(course.id)
  end

  it "Updates a specific course's attributes" do 
  end

end