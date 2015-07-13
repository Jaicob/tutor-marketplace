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

  enum subject: [:biology, :chemistry, :math, :computer_science, :physics]


  def subject_number
    @subject_name = self.subject_id
  end

  def school_name
    school = School.find(self.school_id)
    school.name
  end

  def subject_id
    case self.subject
      when "biology"
        0
      when "chemistry"
        1
      when "math"
        2
      when "computer_science"
        3
      when "physics"
        4
    end
  end

end
