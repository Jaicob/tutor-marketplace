require 'rails_helper'

describe "TutorCourse endpoints" do

  before :each do
    @tutor = create(:tutor)
    @tutor_courses = create_list(:tutor_course, 2, tutor_id: @tutor.id)
  end

  it "Returns all TutorCourses" do
    get "/api/v1/tutors/#{@tutor.id}/tutor_courses"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns a specific TutorCourse" do
    get "/api/v1/tutors/#{@tutor.id}/tutor_courses/#{@tutor_courses.first.id}"
    expect(response).to be_success
    expect(json['id']).to eq(@tutor_courses.first.id)
  end

  it "Updates a specific TutorCourse's attributes" do 
    tutor_course = @tutor.tutor_courses.first
    expect(tutor_course.rate).to eq(30)
    
    params = {rate: 20}
    put uri: "/api/v1/tutors/#{@tutor.id}/tutor_courses/#{tutor_course.id}", id: tutor_course.id, tutor_course: params

    tutor_course.reload
    expect(tutor_course.rate).to eq(20)
  end

end