# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  school_id          :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  approval           :integer
#  degree             :integer          default(0)
#  major              :string
#  additional_degrees :string
#  extra_info_1       :text
#  extra_info_2       :text
#  extra_info_3       :text
#  graduation_year    :string
#  phone_number       :string
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  onboarding_status  :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  last_4_acct        :string
#  line1              :string
#  line2              :string
#  city               :string
#  state              :string
#  postal_code        :string
#  ssn_last_4         :string
#  acct_id            :string
#  slug               :string
#  dob                :date
#  booking_buffer     :integer          default(6)
#

FactoryGirl.define do
  factory :tutor do
    user
    approval 100
    active_status 0
    application_status 0
    degree 0
    major "Biology"
    graduation_year "2019"
    phone_number "555-555-5555"
    extra_info_1 "Default Extra Info 1"
    appt_notes "Default Appt Notes"
    school
    dob Date.today - 10000

    trait :invalid_tutor do
      extra_info_1 nil
    end

    trait :tutor_with_complete_application do
      line1        '101 Axon Way'
      line2        'Suite A'
      city         'Athens'
      state        'GA'
      postal_code  '23123'
      ssn_last_4   '1211'
      acct_id      '123456789'
      last_4_acct  '2222'

      after(:create) do |t|
        t.update_column(:transcript, "/assets/images/file-icon.png")
        t.update_column(:profile_pic, "/assets/images/doge.png")
      end
    end

    trait :with_tutor_course do 
      after(:create) do |tutor|
        course = create(:course, school: tutor.school)
        create(:tutor_course, tutor: tutor, course: course)
      end
    end

    trait :with_tutor_course_and_slot do 
      with_tutor_course
      after(:create) do |tutor|
        create(:slot, tutor: tutor)
      end
    end

    trait :with_one_appointment do 
      with_tutor_course_and_slot
      after(:create) do |tutor|
        create(:appointment, slot: tutor.slots.first)
      end
    end

    trait :with_two_appointments do 
      with_one_appointment
      after(:create) do |tutor|
        create(:appointment, :second, slot: tutor.slots.first)
      end
    end

    trait :with_1_week_availability do 
      after(:create) do |tutor|
        create(:slot, tutor: tutor, start_time: (Date.today + 2.days).to_s + " 12:00")
      end
    end

    trait :with_2_weeks_availability do
      after(:create) do |tutor|
        create(:slot, tutor: tutor, start_time: (Date.today + 2.days).to_s + " 12:00")
        create(:slot, tutor: tutor, start_time: (Date.today + 9.days).to_s + " 12:00")
      end 
    end

    trait :with_semester_availability do 
      after(:create) do |tutor|
        start_date = Date.today + 2.days 
        18.times do
          create(:slot, tutor: tutor, start_time: start_date.to_s + " 12:00")
          start_date = start_date + 7.days
        end
      end
    end

    trait :booked_two_weeks do 
      with_semester_availability
      after(:create) do |tutor|
        first_slot = tutor.slots.second
        second_slot = tutor.slots.third
        create(:appointment, slot: first_slot, start_time: first_slot.start_time.to_date.to_s + " 12:00")
        create(:appointment, slot: second_slot, start_time: second_slot.start_time.to_date.to_s + " 12:00")
      end
    end
  end
end