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

class CsvCourseList < ActiveRecord::Base
  mount_uploader :csv_file, CsvCourseListUploader

end
