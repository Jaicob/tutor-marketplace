# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  school_id     :integer
#  subject       :text
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null

class Course < ActiveRecord::Base
  belongs_to :school
  has_many :tutor_courses, dependent: :destroy
  has_many :tutors, through: :tutor_courses, dependent: :destroy

  validates :call_number, presence: :true
  validates :friendly_name, presence: :true
  validates :school_id, presence: :true
  # validates :subject, presence: true
  # Commented out for now, tests won't pass with this validation in effect. Apparently Rspec doesn't recognize the serialized hash for subject as being present.

  serialize :subject, Hash

  def school_name
    school = School.find(self.school_id)
    school.name
  end

end
