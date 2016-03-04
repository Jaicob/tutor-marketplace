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
#  timezone               :string
#

class School < ActiveRecord::Base
  has_many :courses
  has_many :users
  has_many :tutors
  has_many :students
  has_many :student_groups
  has_many :tutor_courses, through: :tutors, dependent: :destroy
  has_many :appointments, through: :courses, dependent: :destroy
  has_many :slots, through: :tutors, dependent: :destroy
  has_one  :campus_manager, dependent: :destroy

  validates :name, :location, :transaction_percentage, :timezone, presence: true

  after_create :make_campus_manager

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
    courses = []
    self.courses.find_all do |course|
      courses << course if course.subject_id == subject_id.to_i
    end
    sorted_courses = courses.sort_by do |course|
      course.call_number
    end
    return sorted_courses
  end

  def top_subjects
    # This is a short-term solution only. We can manually set the top 4 subjects for each campus while we have a small number of campuses. Eventually we will want to replace the manual lists with a method that determines the most popular subjects by appointments booked or tutor courses, etc.
    case self.name
    when 'University of North Carolina'
      ['Math 101', 'Biology 101', 'Chemistry 101', 'Accounting 101']
    when 'University of Georgia'
      ['Math 101', 'Biology 101', 'Chemistry 101', 'Accounting 101']
    when 'Duke University'
      ['Math 101', 'Biology 101', 'Chemistry 101', 'Accounting 101']
    when 'Clemson University'
      ['Math 101', 'Biology 101', 'Chemistry 101', 'Accounting 101']
    end
  end

  def active_tutors
    self.tutors.where(active_status: 1)
  end

  def make_campus_manager
    email = self.slug + '-no-email@axontutors.com'
    campus_manager = User.create(email: email, password: 'password', first_name: 'No', last_name: 'Manager')
    self.create_campus_manager(user: campus_manager)
  end

  def revenue
    charges = self.appointments.map{|appt| appt.charge}
    revenue = charges.map(&:amount).reduce(:+) || 0
    return revenue
  end

  def profit
    charges = self.appointments.map{|appt| appt.charge}
    profit = charges.map(&:axon_fee).reduce(:+) || 0
    return profit
  end

  def reviews
    self.appointments.select{|appt| appt.review}.map{|appt| appt.review}
  end

end