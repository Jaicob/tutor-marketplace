# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  rating             :integer
#  degree             :string
#  major              :string
#  extra_info         :string
#  graduation_year    :string
#  phone_number       :string
#  birthdate          :date
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :tutor do
    user
    rating 1
    active_status 0
    application_status 0
    birthdate "1992-05-28"
    degree "B.A."
    major "Biology"
    graduation_year "2019"
    phone_number "555-555-5555"
    extra_info "Student Research Assistant for Biology Department"

      factory :invalid_tutor do
        extra_info nil
      end

      factory :tutor_with_complete_application do
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
  end
end
