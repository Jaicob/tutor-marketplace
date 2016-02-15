# == Schema Information
#
# Table name: promotion_redemptions
#
#  id           :integer          not null, primary key
#  student_id   :integer          not null
#  promotion_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :promotion_redemption do
    student_id 1
    promotion_id 1
  end

end
