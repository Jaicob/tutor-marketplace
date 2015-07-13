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
    subjects = self.courses.map do |course|  
      {
        subject: course.subject,
        subject_number: course.subject_id
      }
    end.uniq { |x| x[:subject] }
  end
  
end