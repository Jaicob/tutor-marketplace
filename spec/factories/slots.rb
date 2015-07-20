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
#  start_dow_time  :string
#  end_dow_time    :string
#

FactoryGirl.define do
  factory :slot do
    tutor
    status 0
    start_time "2015-08-14 12:00:00"
    end_time "2015-08-14 13:00:00"
    reservation_min 1
    reservation_max 4
    start_week_time "Fri 12:00:00" # Normally Calculated
    end_week_time "Fri 13:00:00" # Normally Calculated

    factory :one_slot do 
      start_date  "2015-08-14"
      end_date    "2015-08-15"
    end

    factory :many_slots do 
      start_date  "2015-08-14"
      end_date    "2015-09-14"
      new_start_time = "2015-08-14 12:00:00"
      new_end_time = "2015-08-14 13:00:00" 
    end

  end
end
