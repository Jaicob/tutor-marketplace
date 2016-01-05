# == Schema Information
#
# Table name: csv_course_lists
#
#  id         :integer          not null, primary key
#  school_id  :integer
#  subject_id :integer
#  csv_file   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :csv_course_list do
    school_id 1
subject_id 1
  end

end
