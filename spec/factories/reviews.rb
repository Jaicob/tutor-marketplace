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

FactoryGirl.define do
  factory :review do
    appointment
    rating  0
    comment 'This is a test comment'
  end

end
