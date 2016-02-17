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

FactoryGirl.define do
  factory :students_promotion, :class => 'StudentsPromotions' do
    student_id 1
promotion_id 1
  end

end
