# == Schema Information
#
# Table name: reviews
#
#  id             :integer          not null, primary key
#  appointment_id :integer          not null
#  rating         :integer
#  comment        :text
#  follow_up      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Review < ActiveRecord::Base
  belongs_to :appointment

  enum rating: ['Positive', 'Negative']
end
