# == Schema Information
#
# Table name: tutors
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  rating                  :integer
#  status                  :integer
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
#

FactoryGirl.define do
  factory :tutor do
    user nil
    rating 1
    status 1
    birthdate "2015-05-28"
    degree "B.A."
    major "Biology"
    extra_info "Student Research Assistant for Biology Department"
    graduation_year "2019"
    phone_number "706-213-9987"
    transcript 
  end

end
