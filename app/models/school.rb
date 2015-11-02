# == Schema Information
#
# Table name: schools
#
#  id                     :integer          not null, primary key
#  name                   :string
#  location               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string
#  transaction_percentage :float
#

class School < ActiveRecord::Base
  has_many :courses
  has_many :users
  has_many :tutors, through: :users
  has_many :students, through: :users
  has_many :appointments, through: :courses, dependent: :destroy
  has_many :slots, through: :tutors, dependent: :destroy

  validates :name, :location, :transaction_percentage, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  mount_uploader :campus_pic, CampusPicUploader

  # This method is necessary for populating the drop-down menu of subjects in the course selector form
  def subjects
    self.courses.map { |course|
      {
        name: course.subject[:name],
        id:   course.subject[:id]
      }
    }.uniq { |course| course[:name] }
  end

  # This method is necessary for populating the drop-down menu of courses in the course selector form
  def courses_for_subject(subject_id)
    self.courses.find_all do |course|
      course.subject_id == subject_id.to_i
    end
  end


end
