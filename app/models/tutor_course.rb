class TutorCourse < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :course
end
