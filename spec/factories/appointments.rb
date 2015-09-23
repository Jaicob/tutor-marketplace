# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  course_id  :integer
#  start_time :datetime
#  charge_id  :integer
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :appointment do
    student
    slot 
    course
    start_time '2015-09-01 12:00'
    status 0

    trait :second do
      start_time '2015-09-01 13:00'
    end

  end
end
