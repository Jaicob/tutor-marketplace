# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  school_id     :integer
#  subject       :integer
#

require 'rails_helper'

RSpec.describe Course, type: :model do

  it "returns it's school name for .school_name" do
    course = create(:course)
    expect(course.school_name).to eq('University of Georgia')
  end

  it "returns the subject enum integer for .subject_id" do
    # {"biology"=>0, "chemistry"=>1, "math"=>2, "computer_science"=>3, "physics"=>4}
    bio_course = create(:course, friendly_name: 'bio 101', subject: 0)
    expect(bio_course.subject_id).to eq(0)
  end
end