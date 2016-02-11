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

class PromotionRedemption < ActiveRecord::Base
  belongs_to :student
  belongs_to :promotion
end
