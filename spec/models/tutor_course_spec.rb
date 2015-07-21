# == Schema Information
#
# Table name: tutor_courses
#
#  id         :integer          not null, primary key
#  tutor_id   :integer
#  course_id  :integer
#  rate       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorCourse, type: :model do

  it "is valid with a tutor_id, course_id and rate" do
    expect(build(:tutor_course)).to be_valid 
  end

  it "is invalid without a tutor_id" do 
    expect(build(:tutor_course, tutor_id: nil)).not_to be_valid
  end

  it "is invalid without a course_id" do 
    expect(build(:tutor_course, course_id: nil)).not_to be_valid
  end

  it "is invalid without a rate" do 
    expect(build(:tutor_course, rate: nil)).not_to be_valid
  end

  it "returns a nicely formatted name with .formatted_name" do 
    expect(build(:tutor_course).formatted_name).to start_with("Chemistry 101: Intro to Chemistry at University") # University number will change, start_with and leaving off number avoids that problem
  end

end