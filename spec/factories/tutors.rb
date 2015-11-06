# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  rating             :integer
#  degree             :integer          default(0)
#  major              :string
#  extra_info_1       :text
#  extra_info_2       :text
#  extra_info_3       :text
#  graduation_year    :string
#  phone_number       :string
#  birthdate          :date
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  courses_approved   :boolean          default(FALSE)
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
#

FactoryGirl.define do
  factory :tutor do
    user
    rating 1
    active_status 0
    application_status 0
    birthdate "1992-05-28"
    degree 0
    major "Biology"
    graduation_year "2019"
    phone_number "555-555-5555"
    extra_info "Default Extra Info"
    appt_notes "Default Appt Notes"

      factory :invalid_tutor do
        extra_info nil
      end

      factory :tutor_with_complete_application do
        line1        '101 Axon Way'
        line2        'Suite A'
        city         'Athens'
        state        'GA'
        postal_code  '23123'
        ssn_last_4   '1211'
        acct_id      '123456789'
        last_4_acct  '2222'

        after :create do |t|
          t.update_column(:transcript, "/assets/images/file-icon.png")
          t.update_column(:profile_pic, "/assets/images/doge.png")
        end
      end

      factory :second_complete_tutor do
        degree 'PhD'
        major 'Chemistry'
        graduation_year '2017'
        phone_number '999-999-9999'
      end

      trait :at_UNC do
        association :user, factory: [:user, :UNC]
      end

      trait :with_tutor_courses do 
        after :create do |tutor|
          course = create(:course)
          tutor_course = create(:tutor_course, tutor: tutor, course: course)
        end
      end
  end
end
