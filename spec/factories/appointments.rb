# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  course_id  :integer
#  start_time :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :integer
#  location   :string
#

FactoryGirl.define do
  factory :appointment do
    student
    slot 
    course
    start_time (Date.today + 2).to_s + ' 12:00'
    status 0

    trait :second do
      start_time (Date.today + 2).to_s + ' 13:00'
    end

    trait :completed_without_review do 
      status 2
    end

    trait :completed_with_review do 
      status 2
      after(:create) do |appt|
        create(:review, appointment: appt)
      end
    end

  end
end
