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

  def formatted_name
    "#{self.course.subject.name} #{self.course.call_number}: #{self.course.friendly_name}"
  end

  def full_price
    transaction_fee = ((self.course.school.transaction_percentage / 100) + 1)
    full_price = (transaction_fee * self.rate).round(2)
  end
end