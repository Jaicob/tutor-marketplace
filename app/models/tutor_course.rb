# == Schema Information
#
# Table name: tutor_courses
#
#  id         :integer          not null, primary key
#  tutor_id   :integer
#  course_id  :integer
#  rate       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TutorCourse < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :course

  def set_courses(tutor_course_object, params)
    course_id = params[:course][:course_id]
    course = Course.find(course_id)
    course.tutor_course_ids=(tutor_course_object.id)
  end

end


