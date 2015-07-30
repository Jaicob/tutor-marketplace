require 'rails_helper'

describe "Search endpoints" do 

  it "Returns all tutors at a school" do
    get "/api/v1/search/tutors?school_id=1"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns all tutors at a school for a course" do
    get "/api/v1/search/tutors?school_id=1&course_id=1"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns all tutors at a school for a course on a dow" do
    get "/api/v1/search/tutors?school_id=1&course_id=1&dow=4"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns all tutors for a course" do
    get "/api/v1/search/tutors?course_id=1"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns all tutors for a dow" do 
    get "/api/v1/search/tutors?dow=4"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end

  it "Returns all tutors for a course and dow" do 
    get "/api/v1/search/tutors?course_id=1&dow=4"
    expect(response).to be_success
    expect(json.length).to eq(2)
  end
end