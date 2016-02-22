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

FactoryGirl.define do
  factory :review do
    appointment
    rating  0
    comment 'This is a test comment'
  end

end
