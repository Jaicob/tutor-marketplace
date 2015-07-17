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

  it "sets the first tutor course on tutor creation with .set_tutor_and_course_id" do 
    
  end

end


  # def set_tutor_and_course_id(tutor_course, params)
  #   tutor_course.course_id = params[:course][:course_id]
  #   tutor_course.tutor_id = params[:tutor_id]
  # end

  # def formatted_name
  #   "#{self.course.subject} #{self.course.call_number}: #{self.course.friendly_name} at #{self.course.school_name}"
  # end
