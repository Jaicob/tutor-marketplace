require 'rails_helper'

describe "Course endpoints" do 
  let(:course) { create(:course) }
  let(:school) { create(:school) }
  let(:subject) { create(:subject) }

  before :each do 
    @courses = create_list(:course, 3, school_id: school.id, subject_id: subject.id)
  end

  it "Returns all courses for a school and subject" do
    get "/api/v1/schools/#{school.id}/subjects/#{subject.id}/courses"
    expect(response).to be_success
    expect(json.length).to eq(3)
  end

end