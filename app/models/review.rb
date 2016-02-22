# == Schema Information
#
# Table name: reviews
#
#  id             :integer          not null, primary key
#  appointment_id :integer          not null
#  rating         :integer
#  comment        :text
#  follow_up      :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Review < ActiveRecord::Base
  belongs_to :appointment

  validates :appointment_id, :rating, presence: true

  delegate :student, :tutor, to: :appointment

  enum rating: ['Positive', 'Negative']
  enum follow_up: ['None', 'Attempted Contact', 'Contacted Succesfully']
end
