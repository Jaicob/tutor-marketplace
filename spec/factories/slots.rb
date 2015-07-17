# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  end_time        :datetime
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :slot do
    tutor
    status 0
    start_time "2015-07-14 15:59:52"
    end_time "2015-07-14 15:59:52"
    reservation_min 1
    reservation_max 4

    factory :slot_creator_one_slot do 
      tutor
      start_date  "2015-08-01"
      end_date    "2015-08-02"
      start_time  "2015-07-01 12:00"
      end_time    "2015-07-01 16:00"
    end
  end
end
