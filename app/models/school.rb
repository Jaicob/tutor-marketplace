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
  has_many :subjects

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  # add some sort of association so we can call tutors directly on school, perhaps through a has-many through assocation

  # Need to add Active Record assocations to schools for their courses and tutors


  def subjects
    subjects = []
    self.courses.each do |course|
      subjects << course.subject.name unless subjects.include?(course.subject.name)
    end
    subjects
  end

  def courses_friendly_names
    friendly_names = []
    self.courses.each do |course|
      friendly_names << course.friendly_name unless friendly_names.include?(course.friendly_name)
    end
    friendly_names
  end

  def courses_call_numbers
    call_numbers = []
    self.courses.each do |course|
      call_numbers << course.call_number unless call_numbers.include?(course.call_number)
    end
    call_numbers
  end

  def courses_names_and_call_numbers
    list = []
    self.courses.each do |course|
      list << "#{course.call_number} #{course.friendly_name}" unless list.include?("#{course.call_number} #{course.friendly_name}")
    end
    list
  end

  def subjects_courses
  end


  # - list of all schools
  # - list of all subjects in a school
  # - list of all courses in a subject in a school

end
