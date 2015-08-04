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
  has_many :users
  has_many :tutors, through: :users
  has_many :students, through: :users
  has_many :appointments, through: :students, dependent: :destroy
  has_many :slots, through: :tutors, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  # This method is necessary for populating the drop-down menu of subjects in the course selector forms
  def subjects
    self.courses.map { |course|
      {
        name: course.subject[:name],
        id:   course.subject[:id]
      }
    }.uniq { |course| course[:name] }
  end


end
