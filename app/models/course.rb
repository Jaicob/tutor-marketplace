# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  school_id     :integer
#

class Course < ActiveRecord::Base
  belongs_to :subject
  has_many :tutor_courses
  has_many :tutors, through: :tutor_courses


  def self.list_call_numbers
    call_numbers = []
    Course.all.each do |course|
      call_numbers << course.call_number unless course.call_number == nil
    end
    call_numbers
  end

  def self.list_friendly_names
    friendly_names = []
    Course.all.each do |course|
      friendly_names << course.friendly_name unless course.friendly_name == nil
    end
    friendly_names
  end 

  def self.list_courses
    courses = []
    Course.all.each do |course|
      courses << [course.call_number, course.friendly_name]
    end
    courses
  end


end



