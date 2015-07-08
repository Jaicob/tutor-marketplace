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

FactoryGirl.define do
  factory :course do
    subject 1
    call_number 101
    friendly_name "Intro to Chemistry"
    school


    factory :invalid_course do
      subject nil
      school nil
      call_number nil
      friendly_name nil
    end

    factory :second_course do
      subject 2 
      call_number 202
      friendly_name "Cellular Biology"
      association :school, factory: :second_school
    end
  end
end
