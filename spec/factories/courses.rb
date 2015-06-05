# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  school_id     :integer
#

FactoryGirl.define do
  factory :course do
    subject
    call_number 101
    friendly_name "Intro to Chemistry"
  end

end
