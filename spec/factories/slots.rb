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
    status 1
    start_time "2015-07-14 15:59:52"
    end_time "2015-07-14 15:59:52"
    reservation_min 1
    reservation_max 4
  end

end
