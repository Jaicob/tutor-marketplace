# == Schema Information
#
# Table name: student_groups
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :integer
#  school_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StudentGroup < ActiveRecord::Base
  belongs_to :school
  has_many :students
  has_many :promotions

  validates :name, :school_id, presence: true
end
