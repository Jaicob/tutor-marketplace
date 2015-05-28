class Course < ActiveRecord::Base
  belongs_to :subject
  has_many :tutor_courses
end
