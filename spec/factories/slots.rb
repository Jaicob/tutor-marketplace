FactoryGirl.define do
  factory :slot do
    tutor
    status 1
    start_time "2015-08-14 12:00:00"
    end_time "2015-08-14 12:00:00"
    reservation_min 1
    reservation_max 4

    factory :one_slot do 
      start_date  "2015-08-14"
      end_date    "2015-08-15"
    end

    factory :many_slots do 
      start_date  "2015-08-14"
      end_date    "2015-09-14"
    end

  end
end