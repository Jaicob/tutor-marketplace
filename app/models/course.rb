# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  school_id     :integer
#  subject       :text
#  call_number   :string
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Course < ActiveRecord::Base
  belongs_to :school
  has_many :tutor_courses, dependent: :destroy
  has_many :tutors, through: :tutor_courses, dependent: :destroy
  has_many :appointments, dependent: :destroy

  validates :call_number, presence: :true
  validates :friendly_name, presence: :true
  validates :school_id, presence: :true
  validates :subject, presence: true

  serialize :subject, Hash
  # [name: 'Biology',           id: 1]
  # [name: 'Chemistry',         id: 2]
  # [name: 'Math',              id: 3]
  # [name: 'Computer Science',  id: 4]
  # [name: 'Physics',           id: 5]

  def school_name
    school = School.find(self.school_id)
    school.name
  end

  def formatted_name
    "#{self.subject[:name]} #{self.call_number}: #{self.friendly_name}"
  end

end
