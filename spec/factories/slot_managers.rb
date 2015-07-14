# == Schema Information
#
# Table name: slot_managers
#
#  id           :integer          not null, primary key
#  tutor_id     :integer
#  start_date   :date
#  end_date     :date
#  is_recurring :boolean          default(TRUE)
#  exclusions   :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :slot_manager do
    start_date "2015-07-14"
end_date "2015-07-14"
is_recurring false
exclusions "MyText"
  end

end
