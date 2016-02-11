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

require 'rails_helper'

RSpec.describe PromotionRedemption, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
