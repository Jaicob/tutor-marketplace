# == Schema Information
#
# Table name: subjects
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Subject < ActiveRecord::Base
  has_many :courses
  has_many :appointments, through: :courses, dependent: :destroy
  has_many :tutor_courses, through: :courses, dependent: :destroy

end
