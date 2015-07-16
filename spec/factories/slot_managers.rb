# == Schema Information
#
# Table name: slot_managers
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  start_date      :date
#  end_date        :date
#  is_recurring    :boolean          default(TRUE)
#  exclusions      :text
#  start_time      :datetime
#  end_time        :datetime
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :slot_manager do
    tutor   
    start_date    "2015-07-01"
    end_date      "2015-12-20"
    is_recurring  true
    exclusions    nil
    start_time    "2015-07-01 12:00"
    end_time      "2015-07-01 14:00"
  end
end
