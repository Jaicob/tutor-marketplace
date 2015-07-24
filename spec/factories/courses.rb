# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  school_id     :integer
#  subject       :text
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do

  subject_hash = {name: 'Chemistry', id: 1}

  factory :course do
    subject         subject_hash
    call_number     101
    friendly_name   "Intro to Chemistry"
    school

    factory :invalid_course do
      subject   nil
    end

    factory :second_course do
      subject         subject_hash
      call_number     202
      friendly_name   "Cellular Biology"
      association     :school, factory: :second_school
    end
  end
end
