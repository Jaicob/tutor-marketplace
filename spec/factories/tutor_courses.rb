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

FactoryGirl.define do
  factory :tutor_course do
    tutor nil
course nil
rate 1
  end

end
