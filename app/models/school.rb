# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class School < ActiveRecord::Base
  has_many :courses

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  def subjects
    subjects = []
    self.courses.each do |course|
      subjects << course.subject unless subjects.include?(course.subject)
    end
    subjects
  end
  
end