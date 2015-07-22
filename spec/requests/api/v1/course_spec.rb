describe "Course endpoints" do 
  let(:course) { create(:course) }
  let(:school) { create(:school) }
  let(:school_two) { create(:school, :UNC) }  

  before :each do 
    @courses = create_list(:course, 3, school_id: school.id)
    @course = @courses.first
  end

  it "Returns all courses" do
    get "/api/v1/schools/#{school.id}/courses"
    expect(response).to be_success
    expect(json.length).to eq(3)
  end

  it "Returns a course" do 
    get "/api/v1/schools/#{school.id}/courses/#{@course.id}"
    expect(response).to be_success
    expect(json['id']).to eq(@course.id)
  end

end