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
    start_date    "2015-07-15"
    end_date      "2015-12-20"
    is_recurring  true
    exclusions    nil
    start_time    DateTime.now
    end_time      DateTime.now + 1
  end
end
