# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  duration        :integer
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do

  # Always create slots with SlotCreator, rather than a slot factory

  factory :slot do
    association :tutor, :factory => :second_complete_tutor
    status              0
    start_time          "2015-09-01 10:00:00"
    duration            21600 # 6 hours
    # reservation_min     1
    # reservation_max     4

    # factory :one_slot do 
    #   start_date  "2015-08-14"
    #   end_date    "2015-08-15"
    # end

    # factory :many_slots do 
    #   start_date  "2015-08-14"
    #   end_date    "2015-09-14"
    #   new_start_time = "2015-08-14 12:00:00"
    #   new_end_time = "2015-08-14 13:00:00" 
    # end

  end
end
