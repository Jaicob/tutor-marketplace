# == Schema Information
#
# Table name: schools
#
#  id                     :integer          not null, primary key
#  name                   :string
#  location               :string
#  campus_pic             :string
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

  def top_subjects
    # This is a short-term solution only. We can manually set the top 4 subjects for each campus while we have a small number of campuses. Eventually we will want to replace the manual lists with a method that determines the most popular subjects by appointments booked or tutor courses, etc.
    case self.name
    when 'University of North Carolina'
      ['Math', 'Biology', 'Chemistry', 'Accounting']
    when 'University of Georgia'
      ['Math', 'Biology', 'Chemistry', 'Accounting']
    when 'Duke University'
      ['Math', 'Biology', 'Chemistry', 'Accounting']
    when 'Clemson University'
      ['Math', 'Biology', 'Chemistry', 'Accounting']
    end
  end

end
