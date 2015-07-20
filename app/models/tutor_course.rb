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

  validates :tutor_id, presence: true
  validates :course_id, presence: true
  validates :rate, presence: true

  def set_tutor_and_course_id(tutor_course, params)
    tutor_course.course_id = params[:course][:course_id]
    tutor_course.tutor_id = params[:tutor_id]
  end

  def formatted_name
    "#{self.course.subject} #{self.course.call_number}: #{self.course.friendly_name} at #{self.course.school_name}"
  end


end


