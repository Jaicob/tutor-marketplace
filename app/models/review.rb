# == Schema Information
#
# Table name: reviews
#
#  id               :integer          not null, primary key
#  appointment_id   :integer          not null
#  rating           :integer
#  comment          :text
#  follow_up_status :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  follow_up_notes  :text
#

class Review < ActiveRecord::Base
  belongs_to :appointment

  validates :appointment_id, :rating, presence: true

  delegate :student, :tutor, to: :appointment

  enum rating: ['Positive', 'Negative']
  enum follow_up_status: ['None', 'Attempted', 'Contacted']

  after_create :update_tutor_rating

  def update_tutor_rating
    tutor =  self.appointment.tutor
    if tutor.reviews.count >= 3 # prevents a tutor with less than 3 ratings from showing percent, will show "--" until 3 reviews reached
      updated_approval_rating = tutor.reviews.select{|review| review.rating == 'Positive'}.count / tutor.reviews.count.to_f * 100
      tutor.update(approval: updated_approval_rating)
    end
  end
end
