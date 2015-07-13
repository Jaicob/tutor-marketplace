# == Schema Information
#
# Table name: courses
#
#  id             :integer          not null, primary key
#  call_number    :integer
#  friendly_name  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  school_id      :integer
#  subject        :integer
#  subject_number :integer
#

class Course < ActiveRecord::Base
  belongs_to :school
  has_many :tutor_courses, dependent: :destroy
  has_many :tutors, through: :tutor_courses, dependent: :destroy

  validates :call_number, presence: :true
  validates :friendly_name, presence: :true
  validates :school_id, presence: :true

  enum subject: ['Biology', 'Chemistry', 'Math', 'Computer Science', 'Physics']


  def subject_number
    @subject_name = self.subject_id
  end

  def school_name
    school = School.find(self.school_id)
    school.name
  end

  def subject_id
    case self.subject
      when "Biology"
        0
      when "Chemistry"
        1
      when "Math"
        2
      when "Computer Science"
        3
      when "Physics"
        4
    end
  end

end
