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

  validates :name, presence: true
  validates :location, presence: true

  # add some sort of association so we can call tutors directly on school, perhaps through a has-many through assocation

  # Need to add Active Record assocations to schools for their courses and tutors

end
