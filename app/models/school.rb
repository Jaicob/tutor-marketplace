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
    self.courses.map { |course|
      {
        name:   course.subject,
        number: course.subject_id
      }
    }.uniq { |x| x[:name] }
  end

end