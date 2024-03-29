# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  school_id     :integer
#  subject_id    :integer
#  call_number   :string
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do

  factory :course do
    subject
    call_number     101
    friendly_name   "Pre Calculus"
    school

    factory :invalid_course do
      subject   nil
    end

    factory :second_course do
      call_number     202
      friendly_name   "Cellular Biology"
    end
  end
end
