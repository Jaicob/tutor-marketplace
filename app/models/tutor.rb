class Tutor < ActiveRecord::Base
  belongs_to :school
  belongs_to :user
  has_many :tutor_courses
end
