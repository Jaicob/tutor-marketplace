# == Schema Information
#
# Table name: students_promotions
#
#  id           :integer          not null, primary key
#  student_id   :integer          not null
#  promotion_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe StudentsPromotion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
