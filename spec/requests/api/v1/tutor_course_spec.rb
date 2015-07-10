describe "TutorCourse API" do 
  let(:tutor_course) { create(:tutor_course) }

  it "Returns all TutorCourses" do
    create_list(:tutor_course, 10)
    get "/api/v1/tutor_courses"
    expect(response).to be_success
    expect(json.length).to eq(10)
  end

  it "Returns a specific TutorCourse" do 
    get "/api/v1/tutor_courses/#{tutor_course.id}"
    expect(response).to be_success
    expect(json['id']).to eq(tutor_course.id)
  end

  it "Updates a specific TutorCourse's attributes" do 
  end

end