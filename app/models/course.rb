# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  school_id     :integer
#  subject       :integer
#

class Course < ActiveRecord::Base
  belongs_to :school
  has_many :tutor_courses, dependent: :destroy
  has_many :tutors, through: :tutor_courses, dependent: :destroy

  validates :call_number, presence: :true
  validates :friendly_name, presence: :true
  validates :school_id, presence: :true

  enum subject: [:biology, :chemistry, :math, :computer_science, :physics]

  def school_name
    school = School.find(self.school_id)
    school.name
  end

  # subjects are stored as enums and therefore always return strings, so this will give us the integer represenation of a subject
  def subject_id
    if    self.subject == "biology"           then 0
    elsif self.subject == "chemistry"         then 1
    elsif self.subject == "math"              then 2
    elsif self.subject == "computer_science"  then 3
    elsif self.subject == "physics"           then 4
    else                                      nil
    end
  end
end