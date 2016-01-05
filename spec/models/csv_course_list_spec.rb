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

require 'rails_helper'

RSpec.describe CsvCourseList, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
