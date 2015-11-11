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
  validates :course_id, uniqueness: { scope: :tutor_id }
  validates :rate, presence: true
  validate  :course_and_tutor_at_same_school

  def formatted_name
    "#{self.course.subject.name} #{self.course.call_number}: #{self.course.friendly_name}"
  end

  def full_price
    transaction_fee = ((self.course.school.transaction_percentage / 100) + 1)
    full_price = (transaction_fee * self.rate).round(2)
  end

  # custom validation
  def course_and_tutor_at_same_school
    tutor_school_id = Tutor.find(tutor_id).school.id
    course_school_id = Course.find(course_id).school.id
    if tutor_school_id != course_school_id
      errors.add(:tutor, "cannot add courses from different school")
    end
  end
end