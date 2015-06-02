# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  school_id     :integer
#

class Course < ActiveRecord::Base
  belongs_to :subject
  has_many :tutor_courses, dependent: :destroy
  has_many :tutors, through: :tutor_courses, dependent: :destroy

  def self.list_courses
    courses = []
    Course.all.each do |course|
      courses << ["#{course.call_number} | #{course.friendly_name}", course.id]
    end
    courses
  end

end



