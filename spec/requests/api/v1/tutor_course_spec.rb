require 'rails_helper'

describe "TutorCourse endpoints" do

  before :each do
    @tutor = create(:tutor)
    @tutor_courses = create_list(:tutor_course, 2, tutor_id: @tutor.id)
    @tutor_course = @tutor_courses.first
  end

  it "returns all tutor_courses" do
    get "/api/v1/tutors/#{@tutor.id}/tutor_courses"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "returns a specific tutor_course" do
    get "/api/v1/tutors/#{@tutor.id}/tutor_courses/#{@tutor_courses.first.id}"
    expect(response).to be_success
    expect(json['id']).to eq(@tutor_courses.first.id)
  end

  it "updates a specific tutor_course's rate" do
    expect(@tutor_course.rate).to eq(30)
    put "/api/v1/tutors/#{@tutor.id}/tutor_courses/#{@tutor_courses.first.id}", params = {rate: 20}
    expect(@tutor_course.reload.rate).to eq(20)
  end

end