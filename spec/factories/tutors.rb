# == Schema Information
#
# Table name: tutors
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  rating          :integer
#  status          :integer
#  birthdate       :date
#  degree          :string
#  major           :string
#  extra_info      :string
#  graduation_year :string
#  phone_number    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :tutor do
    school nil
user nil
rating 1
status 1
birthdate "2015-05-28"
degree "MyString"
major "MyString"
extra_info "MyString"
graduation_year "MyString"
phone_number "MyString"
  end

end
