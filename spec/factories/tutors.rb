# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  rating             :integer
#  application_status :integer          default(0)
#  birthdate          :date
#  degree             :string
#  major              :string
#  extra_info         :string
#  graduation_year    :string
#  phone_number       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  profile_pic        :string
#  transcript         :string
#  active_status      :integer          default(0)
#

FactoryGirl.define do
  factory :tutor do
    extra_info "Student Research Assistant for Biology Department"

      factory :invalid_tutor do
        extra_info nil
      end
  
      factory :complete_tutor do
        association :user, factory: :alternate_user # To avoid validation restrictions with independent user factory v. this user that is genrated as part of a tutor factory
        rating 1
        active_status 0
        application_status 0
        birthdate "2015-05-28"
        degree "B.A."
        major "Biology"
        graduation_year "2019"
        phone_number "706-213-9987"
      end
  end

end
