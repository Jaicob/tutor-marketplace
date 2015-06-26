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
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  # Need to add Active Record assocations to schools for their courses and tutors

end
