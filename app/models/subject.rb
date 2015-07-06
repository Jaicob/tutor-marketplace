# == Schema Information
#
# Table name: subjects
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Subject < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  
  validates :name, presence: true

  # Lists the schools which have courses in this subject
  def schools
    schools = []
    self.courses.each do |course|
      schools << course.school_name unless schools.include?(course.school_name)
    end
    schools
  end

  def tutors
    tutors = []
    self.courses.each do |course|
      course.tutors.each do |tutor|
        tutors << tutor.name unless tutors.include?(tutor.name)
      end
    end
    tutors
  end

end
