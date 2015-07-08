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
    subject
    school
    call_number 101
    friendly_name "Intro to Chemistry"

    factory :invalid_course do
      subject nil
      school nil
      call_number nil
      friendly_name nil
    end

    factory :second_course do 
      call_number 202
      friendly_name "Cellular Biology"
      association :subject, factory: :second_subject
      association :school, factory: :second_school
    end
  end
end
