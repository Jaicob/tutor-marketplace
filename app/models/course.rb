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

  def self.list_courses
    courses = []
    Course.all.each do |course|
      courses << ["#{course.call_number} | #{course.friendly_name}", course.id]
    end
    courses
  end

  def school_name
    school = School.find(self.school_id)
    school.name
  end

end



