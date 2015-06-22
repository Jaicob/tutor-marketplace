# == Schema Information
#
# Table name: tutors
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  rating                  :integer
#  status                  :integer          default(0)
#  birthdate               :date
#  degree                  :string
#  major                   :string
#  extra_info              :string
#  graduation_year         :string
#  phone_number            :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  transcript_file_name    :string
#  transcript_content_type :string
#  transcript_file_size    :integer
#  transcript_updated_at   :datetime
#  profile_pic             :string
#

FactoryGirl.define do
  factory :tutor do
    extra_info "Student Research Assistant for Biology Department"

      factory :invalid_tutor do
        extra_info nil
      end
  
      factory :complete_tutor do
        user
        rating 1
        status 1
        birthdate "2015-05-28"
        degree "B.A."
        major "Biology"
        graduation_year "2019"
        phone_number "706-213-9987"
      end
  end

end
